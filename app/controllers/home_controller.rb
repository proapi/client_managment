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

  def bills_report
    @search = Bill.search(params[:q])
    @bills = @search.result(distinct: true)

    if params[:commit]
      file = Report.bills_report_to_pdf(@bills)
      send_file file, :filename => "raport.pdf", :type => "application/pdf"
      return
    end

    respond_to do |format|
      format.html
    end
  end

  def clearings_report
    @search = Clearing.search(params[:q])
    @clearings = @search.result(distinct: true)

    if params[:commit]
      file = Report.clearings_report_to_pdf(@clearings)
      send_file file, :filename => "raport.pdf", :type => "application/pdf"
      return
    end

    respond_to do |format|
      format.html
    end
  end

  def countries_report
    @search = Clearing.search(params[:q])
    @clearings = @search.result(distinct: true)

    if params[:commit]
      file = Report.countries_report_to_pdf(@clearings)
      send_file file, :filename => "raport.pdf", :type => "application/pdf"
      return
    end

    respond_to do |format|
      format.html
    end
  end

end
