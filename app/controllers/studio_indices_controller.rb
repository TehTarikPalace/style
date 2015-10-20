class StudioIndicesController < ApplicationController
  def new
    @index = StudioIndex.new
  end

  def create
    #do some validation
    path_reg = /\/\/(?<server>[[[:word:]].-]+)\/(?<share>[[:word:]]+)\/(?<path>[[:print:]]*\/{1})*/
    path_validation = path_reg.match(params[:shared_path])
    if path_validation.nil? then
      flash[:error] = "Path invalid"
      redirect_to :back
    else
      #Rails.logger.info "valid_path = #{path_validation}"
      studio_index = StudioIndex.new(studio_index_param)
      studio_index.assign_attributes(:server => path_validation[:server], :share => path_validation[:share],
        :path => path_validation[:path])


      if studio_index.save! then
        flash[:notice] = "Shared index path created"
        redirect_to studio_index_path(studio_index)
      else
        flash[:error] = "Unable to save"
        redirect_to :back
      end
    end

  end

  def show
    @studio_index = StudioIndex.find(params[:id])
    @data_environments = @studio_index.scan_settings

    js :env_dump_path => studio_index_env_dump_path(params[:id], :format => :template )
  end

  #dump contents of StudioEnvironment file, require nav_path parameter to be present
  def env_dump
    if params.has_key? :nav_path then
      #navigate and dump
      index = StudioIndex.find(params[:studio_index_id])
      content = index.dump_studio_environment params[:nav_path]
      xml = Nokogiri::XML content

      studio_schema_path = 'http://schemas.datacontract.org/2004/07/Slb.Studio.Find.Schema'
      microsoft_path = 'http://schemas.microsoft.com/2003/10/Serialization/Arrays'
      @indexes = xml.at_css("Indexes").children.map{ |x| x.text }
      @location = xml.at_css("Location").text
      @repositories = xml.at_css("Repositories").search("Repository").map do |repo|
        {
          :description => repo.at_css("Description").text,
          :name => repo.at_css("Name").text,
          :application => {
            :display_name => repo.at_css("Application").xpath("a:DisplayName",
              'a' => studio_schema_path).text,
            :name => repo.at_css("Application").xpath("a:Name",
              'a' => studio_schema_path).text,
            :version => repo.at_css("Application").xpath("a:Version",
              'a' => studio_schema_path).text
          },
          :parameters => repo.at_css("Parameters").xpath('a:KeyValueOfstringstring',
            'a' => microsoft_path ).map{ |x| [
                x.xpath('a:Key', 'a' => microsoft_path).text,
                x.xpath('a:Value', 'a' => microsoft_path).text
            ]}
        }
      end
      respond_to do |format|
        format.template
      end
    else
      render :nothing => true
    end
  end

  def edit
    @index = StudioIndex.find(params[:id])
    @shared_path = "//#{@index.server}/#{@index.share}/#{@index.path}"
  end

  #  PATCH  /studio_indices/:id
  def update
    path_reg = /\/\/(?<server>[[[:word:]].-]+)\/(?<share>[[:word:]]+)\/(?<path>[[:print:]]*\/{1})*/
    path_validation = path_reg.match(params[:shared_path])

    if path_validation.nil? then
      flash[:error] = "Path Invalid"
      redirect_to :back
    else
      studio_index = StudioIndex.find(params[:id])
      studio_index.assign_attributes(studio_index_param)
      studio_index.assign_attributes(:server => path_validation[:server], :share => path_validation[:share],
        :path => path_validation[:path])

      if studio_index.save! then
        flash[:notice] = "Index Updated"
        redirect_to studio_index_path(studio_index)
      else
        flash[:error] = "Unable to save"
        redirect_to :back
      end
    end

  end

  private

  def studio_index_param
    params.require(:studio_index).permit(:workgroup, :username, :password, :server, :share, :path)
  end
end
