class WelcomeController < ApplicationController
  def index
    @connections = StudioConnection.all
  end

  def settings
  end
end
