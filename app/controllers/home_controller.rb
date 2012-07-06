class HomeController < ApplicationController



  def index
    #@clearings = Clearing.where("payment_date is null")
    @clearings = Clearing.all_cached
  end

  def administration
    @countries = Country.all_cached
    @companies = Company.all_cached
    @documents = Document.all_cached
  end
end
