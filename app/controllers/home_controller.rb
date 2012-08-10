class HomeController < ApplicationController

  before_filter :authenticate_user!

  def index
    @clearings = Clearing.undone
  end

  def administration
    @countries = Country.all_cached
    @companies = Company.all_cached
    @documents = Document.all_cached
    @agents = Agent.all_cached
  end

  def reports
  end
end
