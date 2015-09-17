class WelcomeController < ApplicationController
  def index
    @connections = StudioConnection.all
  end

  def settings
    @connections = StudioConnection.all
  end
end
