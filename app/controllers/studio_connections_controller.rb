class StudioConnectionsController < ApplicationController
  before_action :authenticate_user!

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
    @user_credential = current_user.user_credentials.where(:studio_connection_id => params[:id]).first

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
    dd = conn.query("select max(username) as username from dba_users where username like 'SKS_DD_%'").
      first[:USERNAME]
    if current_user.admin? || current_user.username == ENV["default_admin"] then
      @repositories = conn.query("select
        project, model_version, owner, create_date, modify_date, coordinate_system||':'||name as coordinate_system
        from
        sks_sys.sds_project,
        #{dd}.r_coordinate_ref_system
        where
         coordinate_system = code
        order by project")
    else
      #get current credential
      credential = current_user.user_credentials.where(:studio_connection_id => params[:studio_connection_id]).first
      if credential.nil? then
        @repositories = []
      else
        @repositories = conn.query("select
          project.project, project.model_version, project.owner,
          project.create_date, project.modify_date,
          project.coordinate_system||':'||crs.name as coordinate_system
          from
          sks_sys.sds_project project,
          sks_sys.sds_pipe pipe,
          #{dd}.r_coordinate_ref_system crs
          where
           project.coordinate_system = crs.code
           and pipe.sds_user = '#{credential.username.upcase}'
           and project.project = pipe.account
          order by project")
      end
    end
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

    #check permission
    @allowed = @connection.user_allowed? current_user,  params[:repo_name]

    js :repository => params[:repo_name],
      :allowed => @allowed,
      :content_path =>
        studio_connection_show_repo_path(params[:studio_connection_id], params[:repo_name]) + ".template"

    #conn = StudioConnection.find(params[:studio_connection_id])
    respond_to do |format|
      format.html {
        if !@allowed then
          render :file => "public/403.html", :status => :forbidden
        end
      }
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
    @allowed = @connection.user_allowed? current_user, params[:repo_name]

    @stats = @connection.get_stats params[:repo_name]

    js :stats => @stats, :repo_name => params[:repo_name]

    respond_to do |format|
      format.html {
        if !@allowed then
          render :file => "public/403.html", :status => :forbidden
        end
      }
    end

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
    @allowed = @connection.user_allowed? current_user, params[:repo_name]

    respond_to do |format|
      format.html {
        if !@allowed then
          render :file => "public/403.html", :status => :forbidden
        end
      }
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
    allowed = sc.user_allowed? current_user, params[:repo_name]

     js :users
     respond_to do |format|
       format.html{
        if !allowed then
          render :file => "public/403.html", :status => :forbidden
        else
          @users = sc.query "
            select
              users.account, users.first_name, last_name, email_address, users.create_Date
            from sks_sys.sds_user users, sks_sys.sds_pipe pipe
            where
              users.account = pipe.sds_user
              and pipe.account = '#{params[:repo_name]}'
           "
        end
       }
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

  # GET    /studio_connections/:studio_connection_id/repositories/:repo_name/object_shape/:guid
  # returns the info about the object shape in json format
  def object_shape
    sc = StudioConnection.find(params[:studio_connection_id])
    result = sc.query("select entity_id, entity_tbl, shape from #{params[:repo_name]}.dbx_object where GUID = '#{params[:guid]}'").first

    shape = Hash.new
    #shape[:ordinates] = result[:SHAPE].sdo_ordinates.instance_variable_get("@attributes").each_slice(4)

    if result[:ENTITY_TBL] == 'DovPolylineSet' then
      #find the polylines and push the real shape in
      shapes = sc.query("select shape from #{params[:repo_name]}.dovpolyline where polylineset_id = #{result[:ENTITY_ID]}")
      shape[:shape] = []

      shapes[0..10].each do |polyline|
        shape[:shape] << polyline[:SHAPE].sdo_ordinates.instance_variable_get("@attributes").each_slice(4)
      end
    end

    respond_to do |format|
      format.json { render json: shape  }
    end
  end

  private

  def studio_connection_params
    params.require(:studio_connection).permit(:username, :password, :oracle_host, :oracle_instance)
  end

  def list_collections conn
  end
end
