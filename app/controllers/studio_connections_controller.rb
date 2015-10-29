class StudioConnectionsController < ApplicationController
  def new
    @connection = StudioConnection.new
  end

  def create
    @connection = StudioConnection.new(studio_connection_params)

    if @connection.valid? then
      if @connection.save! then
        flash[:notice] = "New connection created"
        redirect_to root_path
      else
        flash[:error] = "Failed to create new connection"
        redirect_to :back
      end
    else
      flash[:error] = "connection invalid"
      redirect_to :back
    end
  end

  def show
    @connection = StudioConnection.find(params[:id])

    respond_to do |format|
      format.html
      format.template{
      }
    end
  end

  #  GET    /studio_connections/:id
  # always template
  def repositories
    conn = StudioConnection.find(params[:studio_connection_id])
    @repositories = conn.query("select
      project, model_version, owner, create_date, modify_date, coordinate_system from
      sks_sys.sds_project order by project")
  end

  #edit the template
  #  GET    /studio_connections/:id/edit(.:format)
  def edit
    @connection = StudioConnection.find params[:id]

    respond_to do |format|
      format.html
    end
  end

  #  PATCH  /studio_connections/:id
  def update
    @connection = StudioConnection.find params[:id]

    @connection.assign_attributes studio_connection_params

    if @connection.valid? then
      if @connection.save! then
        flash[:notice] = "Studio Connection settings updated"
        redirect_to root_path
      else
        flash[:error] = "Failed to Update Studio Connection"
        redirect_to :back
      end
    else
      flash[:error] = "Wrong!!"
      redirect_to :back
    end
  end

  # GET    /studio_connections/:studio_connection_id/repositories/:repo_name
  # recommended by optional argument
  # guid  gets the parent guid
  def show_repo
    @connection = StudioConnection.find params[:studio_connection_id]
    js :repository => params[:repo_name],
      :content_path =>
        studio_connection_show_repo_path(params[:studio_connection_id], params[:repo_name]) + ".template"

    #conn = StudioConnection.find(params[:studio_connection_id])
    respond_to do |format|
      format.html
      format.template{
        conn = StudioConnection.find(params[:studio_connection_id])
        render :template => "studio_connections/browse_repo.template", :locals => {
           :'@path' => "/", :'@repository' => params[:repo_name], :'@content' => conn.browse(params[:repo_name])
         }
      }
    end
  end

  #GET    /studio_connections/:studio_connection_id/repositories/:repo_name:path(.:format)
  # :format is mandatory, otherwise path cannot be found
  def browse_repo
      @repository = params[:repo_name]
      @path = params[:path]
      @connection = StudioConnection.find(params[:studio_connection_id])
      if !params.has_key?(:guid) then
        conn = StudioConnection.find(params[:studio_connection_id])
        params[:guid] = conn.get_guid @repository, @path
      end

      js :content_path =>
        "/studio_connections/#{params[:studio_connection_id]}/repositories/#{@repository}/input/#{@path}.template?guid=#{params[:guid]}",
        :history_path => studio_connection_object_history_path(params[:studio_connection_id], @repository, params[:guid]),
        :object_dump_path => studio_connection_object_browse_path(params[:studio_connection_id], @repository, params[:guid],
          :format => :template)
      #somehow this doesn't work
      #studio_connection_browse_repo_path(params[:studio_connection_id], @repository,
      #  :path => @path, :guid => params[:guid]) + ".template"

      respond_to do |format|
        format.html{
        }

        format.template {
          conn = StudioConnection.find(params[:studio_connection_id])
          @content = conn.browse(params[:repo_name], params[:path], params[:guid])
        }
      end
  end

  # GET    /studio_connections/:studio_connection_id/history/:repo_name/:guid
  # template only
  def history
    @history = StudioConnection.find(params[:studio_connection_id]).show_history(params[:repo_name], params[:guid])
    respond_to do |format|
      format.template
    end
  end

  # given a repo name and guid, get the oracle entry of said guid, template only
  # GET    /studio_connections/:studio_connection_id/object/:repo_name/:guid
  def object_dump
    conn = StudioConnection.find(params[:studio_connection_id])
    @object = conn.get_object_dump params[:repo_name], params[:guid]

    respond_to do |format|
      format.template
    end
  end

  #  GET    /studio_connections/:studio_connection_id/stats/:repo_name(.:format)
  def repo_stats
    @connection = StudioConnection.find(params[:studio_connection_id])
    @stats = @connection.get_stats params[:repo_name]

    js :stats => @stats, :repo_name => params[:repo_name]
  end

  # GET    /studio_connections/:studio_connection_id/stats/:repo_name/:object
  def repo_object_stats
    sc = StudioConnection.find(params[:studio_connection_id])
    @results = sc.query "select insert_date, count(id) as insert_count
      from #{params[:repo_name]}.#{params[:object]}
      group by insert_date order by insert_date"
    @header_info = StatHeader.lookup params[:object]
    js :stats => @results
  end

  #  DELETE /studio_connections/:id
  def destroy
    sc = StudioConnection.find(params[:id])

    if sc.nil? then
      flash[:notice] = "Connection now found"
    else
      sc.destroy
      flash[:notice] = "Studio Connection deleted"
    end

    redirect_to connections_settings_path
  end

  #GET    /studio_connections/:studio_connection_id/conformity/:repo_name
  def conformity
    @connection = StudioConnection.find(params[:studio_connection_id])
    
    respond_to do |format|
      format.html
      format.template {
        @dir_list = StudioConnection.find(params[:studio_connection_id]).tree params[:repo_name]
      }
    end
  end

  #  GET    /studio_connections/:studio_connection_id/users(.:format)
  def users
    @connection = StudioConnection.find(params[:studio_connection_id])
    @users = @connection.query "select account, create_date, first_name, last_name, email_address from sks_sys.sds_user"
  end

  #  GET    /studio_connections/:studio_connection_id/users/:username
  def user
    sc = StudioConnection.find(params[:studio_connection_id])
    @interface = sc.query "select account from sks_sys.sds_pipe where sds_user = '#{params[:username]}'"
    @privilege = sc.query("select privilege from sks_sys.sds_user where account = '#{params[:username]}'").first

    respond_to do |format|
      format.template
    end
  end

  def repo_users
    sc = StudioConnection.find(params[:studio_connection_id])
    @users = sc.query "
      select
        users.account, users.first_name, last_name, email_address, users.create_Date
      from sks_sys.sds_user users, sks_sys.sds_pipe pipe
      where
        users.account = pipe.sds_user
        and pipe.account = '#{params[:repo_name]}'
     "

     js :users
     respond_to do |format|
       format.html
       format.template
     end
  end

  #GET    /studio_connections/:studio_connection_id/dashboard
  # get dashbaord values
  def dashboard
    @connection = StudioConnection.find(params[:studio_connection_id])
    @dashboard = @connection.dashboard
  end

  # GET    /studio_connections/:studio_connection_id/dashboard/query/:query_id
  def dash_query
    sc = StudioConnection.find(params[:studio_connection_id])
    @query_data = sc.dashboard_query(params[:query_id])

    respond_to do |format|
      format.template
    end
  end

  private

  def studio_connection_params
    params.require(:studio_connection).permit(:username, :password, :oracle_host, :oracle_instance)
  end

  # conn is studio_connection instance
  def list_collections conn

  end
end
