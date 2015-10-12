class SettingsController < ApplicationController
  def index
  end

  def connections
    @connections = StudioConnection.all
  end

  def indexes
    @indexes = StudioIndex.all
  end
end
