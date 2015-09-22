class SettingsController < ApplicationController
  def index
  end

  def connections
    @connections = StudioConnection.all
  end
end
