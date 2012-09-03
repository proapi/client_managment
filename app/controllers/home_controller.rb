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
      if params[:commit].include? 'pdf'
        send_file Report.bills_report_to_pdf(@bills), :filename => "raport.pdf", :type => "application/pdf"
        return
      end

      if params[:commit].include? 'csv'
        send_file Report.bills_report_to_csv(@bills), :filename => "raport.csv", :type => "text/plain"
        return
      end
    end

    respond_to do |format|
      format.html
    end
  end

  def clearings_report
    @search = Clearing.search(params[:q])
    @clearings = @search.result(distinct: true)

    if params[:commit]
      if params[:commit].include? 'pdf'
        send_file Report.clearings_report_to_pdf(@clearings), :filename => "raport.pdf", :type => "application/pdf"
        return
      end

      if params[:commit].include? 'csv'
        send_file Report.clearings_report_to_csv(@clearings), :filename => "raport.csv", :type => "text/plain"
        return
      end
    end

    respond_to do |format|
      format.html
    end
  end

  def countries_report
    @search = Clearing.search(params[:q])
    @clearings = @search.result(distinct: true)

    if params[:commit]
      if params[:commit].include? 'pdf'
        send_file Report.countries_report_to_pdf(@clearings), :filename => "raport.pdf", :type => "application/pdf"
        return
      end

      if params[:commit].include? 'csv'
        send_file Report.countries_report_to_csv(@clearings), :filename => "raport.csv", :type => "text/plain"
        return
      end
    end

    respond_to do |format|
      format.html
    end
  end

end
