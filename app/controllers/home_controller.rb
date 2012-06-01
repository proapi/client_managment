class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    @clearings = Clearing.where("payment_date is not null")
  end

  def administration
    @countries = Country.all
    @companies = Company.all
    @documents = Document.all
  end
end
