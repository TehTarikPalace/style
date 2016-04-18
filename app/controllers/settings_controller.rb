class SettingsController < ApplicationController
  before_action :authenticate_user!
  def index
  end

  def connections
    @connections = StudioConnection.all
  end

  def indexes
    @indexes = StudioIndex.all
  end

  def admins
    @admins = User.where(:admin => true)
  end
end
