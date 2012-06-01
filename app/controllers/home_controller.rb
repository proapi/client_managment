class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    @clients = Client.all
  end

  def administration
    @countries = Country.all
    @companies = Company.all
    @documents = Document.all
  end
end
