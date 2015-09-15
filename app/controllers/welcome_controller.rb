class WelcomeController < ApplicationController
  def index
    @connections = StudioConnection.all
  end
end
