#encoding: utf-8

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

  def file_upload
    file = params[:file_upload][:my_file].tempfile
    @tab = Array.new
    @clients = Array.new
    @clearings = Array.new
    @bills = Array.new
    @bills_rep = Array.new
    @clients_rep = Array.new
    @clearings_rep = Array.new
    @errors = Array.new
    File.open(file, 'r') do |f|
      f.readlines.each_with_index do |line, index|
        if index > 0
          cells_tab = line.chomp.split(';')
          if cells_tab.size == 32
            @tab << cells_tab
            logger.debug "Aktualna linia: #{cells_tab}"
            client = check_client cells_tab
            if client.nil?
              client = create_client cells_tab
              @clients << client unless client.nil?
            else
              @clients_rep << client
            end

            clearing = check_clearing cells_tab
            unless clearing.nil?
              @clearings_rep << clearing
            end
            if clearing.nil? && !client.nil?
              clearing = create_clearing(cells_tab, client) unless client.nil?
              @clearings << clearing unless clearing.nil?
            end

            unless cells_tab[25].empty?
              bill = check_bill cells_tab
              unless bill.nil?
                @bills_rep << bill
              end
              if bill.nil? && !clearing.nil? && !client.nil?
                bill = create_bill(cells_tab, clearing) unless clearing.nil?
                @bills << bill unless bill.nil?
              end

              @errors << cells_tab if bill.nil? || client.nil? || clearing.nil?
            else
              @errors << cells_tab if client.nil? || clearing.nil?
            end
          else
            @errors << cells_tab
          end
        end
      end
    end
  end

  private
  def check_client(cells_tab)
    Client.where("lastname=? AND firstname=? AND birthdate=?", cells_tab[0], cells_tab[1], prepare_date(cells_tab[5], '19')).first
  end

  def create_client(cells_tab)
    client = Client.new
    client.address = Address.new
    client.mailing_address = Address.new
    client.mailing_address.kind = 'mailing_address'
    client.address.street = cells_tab[2] unless cells_tab[2].empty?
    client.address.city = cells_tab[4] unless cells_tab[4].empty?
    client.address.code = cells_tab[3] unless cells_tab[3].empty?
    client.address.kind = 'address'
    client.lastname = cells_tab[0] unless cells_tab[0].empty?
    client.firstname = cells_tab[1] unless cells_tab[1].empty?
    client.birthdate = prepare_date(cells_tab[5], '19') unless cells_tab[5].empty?
    client.telephone = cells_tab[6] unless cells_tab[6].empty?
    client.mobile = cells_tab[7] unless cells_tab[7].empty?
    client.email = cells_tab[8] unless cells_tab[8].empty?
    client.user_id = current_user.id

    client.save ? client : nil
  end

  def check_clearing(cells_tab)
    Clearing.where('tax_number=? AND year=? AND rebate_final=?', cells_tab[9], cells_tab[10], cells_tab[20]).first
  end

  def create_clearing(cells_tab, client)
    clearing = Clearing.new
    clearing.tax_number = cells_tab[9] unless cells_tab[9].empty?
    clearing.year = cells_tab[10] unless cells_tab[10].empty?
    clearing.application_date = prepare_date(cells_tab[11]) unless cells_tab[11].empty? #data
    clearing.commission_percent = cells_tab[12].split(',').join('.') unless cells_tab[12].empty? #liczba
    clearing.commission_min = cells_tab[13].split(',').join('.') unless cells_tab[13].empty? #liczba
    clearing.commission_currency = cells_tab[14] unless cells_tab[14].empty?
    clearing.rebate_calc = cells_tab[16].split(',').join('.') unless cells_tab[16].empty? #liczba
    clearing.office_send_date = prepare_date(cells_tab[17]) unless cells_tab[17].empty? #data
    clearing.decision_date = prepare_date(cells_tab[19]) unless cells_tab[19].empty? #data
    clearing.rebate_final = cells_tab[20].split(',').join('.') unless cells_tab[20].empty? #liczba
    clearing.exchange_rate = cells_tab[21].split(',').join('.') unless cells_tab[21].empty? #liczba
    clearing.commission_date = prepare_date(cells_tab[22]) unless cells_tab[22].empty? #data
    clearing.commission_final = cells_tab[23].split(',').join('.') unless cells_tab[23].empty? #liczba
    clearing.payment_date = prepare_date(cells_tab[26]) unless cells_tab[26].empty? #data
    clearing.income_total = cells_tab[27].split(',').join('.') unless cells_tab[27].empty? #liczba  WPŁYW NA KONTO WBK kolumna AB!!!
    clearing.total_to_client = cells_tab[28].split(',').join('.') unless cells_tab[28].empty? #liczba
    clearing.income_exchange_rate = cells_tab[29].split(',').join('.') unless cells_tab[29].empty? #liczba
    clearing.agent_date = prepare_date(cells_tab[30]) unless cells_tab[30].empty? #data
    agent = Agent.where(name: cells_tab[31]).first
    if agent
      clearing.agent_id = agent.id
    else
      clearing.agent_id = Agent.where(name: 'INNY').first.id
    end

    unless cells_tab[27].empty? #columna AB
      clearing.bill_amount = cells_tab[23].split(',').join('.') unless cells_tab[23].empty? #liczba
      clearing.to_client_date = prepare_date(cells_tab[26]) unless cells_tab[26].empty? #data
      clearing.bank_account_destination = 'Zwrot podatku na konto firmy'
    end

    clearing.client_id = client.id
    clearing.user_id = current_user.id
    country = Country.where(short: cells_tab[15]).first
    clearing.country_id = country.id
    clearing.archive = true

    clearing.save ? clearing : nil
  end

  def check_bill(cells_tab)
    if cells_tab[25][0].eql?('K')
      company = Company.where(short: 'EP JAKUB').first
    else
      company = Company.where(short: 'EP GRAŻYNA').first
    end

    str = String.new cells_tab[25][1..-1]
    Bill.where('number=? AND company_id=?', str, company.id).first
  end

  def create_bill(cells_tab, clearing)
    if cells_tab[25][0].eql?('K')
      company = Company.where(short: 'EP JAKUB').first
    else
      company = Company.where(short: 'EP GRAŻYNA').first
    end

    bill = Bill.new
    bill.issue_date = prepare_date(cells_tab[22]) unless cells_tab[22].empty? #data
    bill.total = cells_tab[23].split(',').join('.') unless cells_tab[23].empty? #liczba
    bill.maturity_date = prepare_date(cells_tab[24]) unless cells_tab[24].empty? #data
    if cells_tab[25][0].eql?('K')
      bill.number = cells_tab[25][1..-1]
    else
      bill.number = cells_tab[25]
    end
    if cells_tab[27].empty? #columna AB
      bill.title = 'Usługa biurowa'
      bill.payment_form = 'Przelew'
    else
      bill.title = 'Usługa inkasa'
      bill.payment_form = 'Pobranie'
    end
    bill.units = 'szt.'
    bill.clearing_id = clearing.id
    bill.user_id = current_user.id
    bill.company_id = company.id

    bill.save ? bill : nil
  end

  def prepare_date(date, sufix = '20')
    str = String.new date
    Date.strptime(str.insert(-3, sufix), '%d-%m-%Y')
  end

end
