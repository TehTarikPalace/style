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
      Rails.logger.info "valid_path = #{path_validation}"
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
    @settings_dump = @studio_index.dump_settings
  end

  private

  def studio_index_param
    params.require(:studio_index).permit(:workgroup, :username, :password, :server, :share, :path)
  end
end
