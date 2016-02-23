class WelcomeController < ApplicationController
  def index
    @connections = StudioConnection.all
    @indices = StudioIndex.all
  end

  def settings
  end
end
