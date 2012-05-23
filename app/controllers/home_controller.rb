class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    @clients = Client.all
  end
end
