#encoding: utf-8
require 'prawn'
require 'csv'

class Report
  def self.create_envelope(client, company)
    pdf = Prawn::Document.new(page_size: "C5")
    pdf.font_families.update("mine" => {
        :bold => "#{Rails.root}/app/assets/fonts/DejaVuSans-Bold.ttf",
        :italic => "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf",
        :bold_italic => "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf",
        :normal => "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"})
    pdf.font("mine")
    pdf.font_size 12

    pdf.text_box("#{company.name}", :at => [20, 20], :width => 400, :height => 100, :rotate => 90, :rotate_around => :upper_left)
    pdf.text_box("#{company.address.street}", :at => [45, 20], :width => 400, :height => 100, :rotate => 90, :rotate_around => :upper_left)
    pdf.text_box("#{company.address.code} #{company.address.city}", :at => [70, 20], :width => 400, :height => 100, :rotate => 90, :rotate_around => :upper_left)

    pdf.font_size 14

    pdf.text_box("#{client.fullname}", :at => [240, 300], :width => 400, :height => 100, :rotate => 90, :rotate_around => :upper_left)
    pdf.text_box("#{client.mailing_address.street}", :at => [270, 300], :width => 400, :height => 100, :rotate => 90, :rotate_around => :upper_left)
    pdf.text_box("#{client.mailing_address.code} #{client.mailing_address.city}", :at => [300, 300], :width => 400, :height => 100, :rotate => 90, :rotate_around => :upper_left)

    file = File.join(Rails.root, "tmp", "envelope.pdf")
    pdf.render_file file

    file
  end

  def self.bills_report_to_pdf(bills)
    generate_pdf do |pdf|
      pdf.text "Raport rachunków", style: :bold

      pdf.font_size 9

      pdf.move_down 15

      table_data = Array.new
      table_data << ["Nazwisko", "Imię", "Numer rachunku", "Kwota z rachunku", "Kwota zapłacona", "Różnica kwot", "Data zapłaty"]
      bills.each do |bill|
        bill.clearing.income_total = bill.total if bill.clearing.income_total.nil? && bill.clearing.archive?
        table_data << ["#{bill.clearing.client.lastname}",
                       "#{bill.clearing.client.firstname}",
                       "#{bill.number}",
                       "#{ActionController::Base.helpers.number_with_precision(bill.total, precision: 2, delimiter: " ")}",
                       "#{bill.clearing.income_total.nil? ? '' : ActionController::Base.helpers.number_with_precision(bill.total, precision: 2, delimiter: " ")}",
                       "#{bill.clearing.income_total.nil? ? '' : ActionController::Base.helpers.number_with_precision(0, precision: 2, delimiter: " ")}",
                       "#{bill.clearing.payment_date.nil? ? '' : ActionController::Base.helpers.localize(bill.clearing.payment_date)}"]
      end
      pdf.table(table_data, header: true, width: 520, position: :center)
    end
  end

  def self.clearings_report_to_pdf(clearings)
    generate_pdf do |pdf|
      pdf.text "Raport rozliczeń", style: :bold

      pdf.font_size 8

      pdf.move_down 15

      clearings.group_by(&:year).sort.each do |year, clearings_by_year|
          table_data = Array.new
          table_data << ["Nazwisko", "Imię", "Nr podatkowy", "Rok rozliczenia", "Kraj", "Prowizja min", "Prowizja %", "Kwota wyliczona", "Data wysłania do urzędu", "Data decyzji", "Kwota zwrotu z decyzji", "Kwota do zapłaty", "Termin zapłaty", "Data otrzymania zapłaty", "Agent", "Data rozliczenia z agentem"]
          clearings_by_year.each do |c|
            table_data << ["#{c.client.nil? ? "Brak" : c.client.lastname}",
                           "#{c.client.nil? ? "Brak" : c.client.firstname}",
                           "#{c.tax_number}",
                           "#{c.year}",
                           "#{c.country.nil? ? "Brak" : c.country.name}",
                           "#{c.commission_min.nil? ? "Brak" : ActionController::Base.helpers.number_with_precision(c.commission_min, precision: 2, delimiter: " ")}",
                           "#{c.commission_percent.nil? ? "Brak" : ActionController::Base.helpers.number_with_precision(c.commission_percent, precision: 2, delimiter: " ")}",
                           "#{c.rebate_calc.nil? ? "Brak" : ActionController::Base.helpers.number_with_precision(c.rebate_calc, precision: 2, delimiter: " ")}",
                           "#{c.office_send_date.nil? ? "Brak" : ActionController::Base.helpers.localize(c.office_send_date)}",
                           "#{c.decision_date.nil? ? "Brak" : ActionController::Base.helpers.localize(c.decision_date)}",
                           "#{c.rebate_final.nil? ? "Brak" : ActionController::Base.helpers.number_with_precision(c.rebate_final, precision: 2, delimiter: " ")}",
                           "#{c.commission_final.nil? ? "Brak" : ActionController::Base.helpers.number_with_precision(c.commission_final, precision: 2, delimiter: " ")}",
                           "#{c.bill.nil? ? "Brak" : ActionController::Base.helpers.localize(c.bill.maturity_date)}",
                           "#{c.payment_date.nil? ? "Brak" : ActionController::Base.helpers.localize(c.payment_date)}",
                           "#{c.agent.nil? ? "Brak" : c.agent.name}",
                           "#{c.agent_date.nil? ? "Brak" : ActionController::Base.helpers.localize(c.agent_date)}"]
          end
          pdf.table(table_data, header: true, width: 520, position: :center, :cell_style => {:size => 6})
          pdf.move_down 10
      end
    end
  end

  #def self.countries_report_to_pdf(clearings)
  #  generate_pdf do |pdf|
  #    pdf.text "Raport rozliczeń w danym roku", style: :bold
  #
  #    pdf.font_size 9
  #
  #    pdf.move_down 10
  #
  #    clearings.group_by(&:year).sort.each do |year, clearings_by_year|
  #      pdf.move_down 15
  #      pdf.text "Rok rozliczenia: <b>#{year}</b>", inline_format: true
  #      clearings_by_year.group_by(&:month).sort.each do |month, clearings_by_month|
  #        pdf.text "Miesiąc: <b>#{month}</b> Ilość rozliczeń: <b>#{clearings_by_month.size}</b>", inline_format: true
  #      end
  #      pdf.move_down 15
  #
  #      clearings_by_year.group_by(&:country).sort.each do |country, clearings_by_country|
  #        pdf.text "Kraj: <b>#{clearings_by_country.first.country.name}</b> Ilość wystawionych rozliczeń dla kraju: <b>#{clearings_by_country.size}</b>", inline_format: true
  #      end
  #    end
  #  end
  #end

  def self.bills_report_to_csv(bills)
    string = CSV.generate(:col_sep => ";") do |csv|
      csv << ["Nazwisko", "Imię", "Numer rachunku", "Kwota z rachunku", "Kwota zapłacona", "Różnica kwot", "Data zapłaty"]
      bills.each do |bill|
        bill.clearing.income_total = bill.total if bill.clearing.income_total.nil? && bill.clearing.archive?
        csv << ["#{bill.clearing.client.lastname}",
                "#{bill.clearing.client.firstname}",
                "#{bill.number}",
                "#{ActionController::Base.helpers.number_with_precision(bill.total, precision: 2, delimiter: " ")}",
                "#{bill.clearing.income_total.nil? ? '' : ActionController::Base.helpers.number_with_precision(bill.total, precision: 2, delimiter: " ")}",
                "#{bill.clearing.income_total.nil? ? '' : ActionController::Base.helpers.number_with_precision(0, precision: 2, delimiter: " ")}",
                "#{bill.clearing.payment_date.nil? ? '' : ActionController::Base.helpers.localize(bill.clearing.payment_date)}"]
      end
    end

    file = File.join(Rails.root, "tmp", "raport.csv")
    File.open(file, 'w:cp1250') do |f|
      f.write string.encode("cp1250")
    end
    file
  end

  def self.clearings_report_to_csv(clearings)
    string = CSV.generate(:col_sep => ";") do |csv|
      clearings.group_by(&:year).sort.each do |year, clearings_by_year|
          csv << ["Nazwisko", "Imię", "Nr podatkowy", "Rok rozliczenia", "Kraj", "Prowizja min", "Prowizja %", "Kwota wyliczona", "Data wysłania do urzędu", "Data decyzji", "Kwota zwrotu z decyzji", "Kwota do zapłaty", "Termin zapłaty", "Data otrzymania zapłaty", "Agent", "Data rozliczenia z agentem"]
          clearings_by_year.each do |c|
            csv << ["#{c.client.nil? ? "Brak" : c.client.lastname}",
                                       "#{c.client.nil? ? "Brak" : c.client.firstname}",
                                       "#{c.tax_number}",
                                       "#{c.year}",
                                       "#{c.country.nil? ? "Brak" : c.country.name}",
                                       "#{c.commission_min.nil? ? "Brak" : ActionController::Base.helpers.number_with_precision(c.commission_min, precision: 2, delimiter: " ")}",
                                       "#{c.commission_percent.nil? ? "Brak" : ActionController::Base.helpers.number_with_precision(c.commission_percent, precision: 2, delimiter: " ")}",
                                       "#{c.rebate_calc.nil? ? "Brak" : ActionController::Base.helpers.number_with_precision(c.rebate_calc, precision: 2, delimiter: " ")}",
                                       "#{c.office_send_date.nil? ? "Brak" : ActionController::Base.helpers.localize(c.office_send_date)}",
                                       "#{c.decision_date.nil? ? "Brak" : ActionController::Base.helpers.localize(c.decision_date)}",
                                       "#{c.rebate_final.nil? ? "Brak" : ActionController::Base.helpers.number_with_precision(c.rebate_final, precision: 2, delimiter: " ")}",
                                       "#{c.commission_final.nil? ? "Brak" : ActionController::Base.helpers.number_with_precision(c.commission_final, precision: 2, delimiter: " ")}",
                                       "#{c.bill.nil? ? "Brak" : ActionController::Base.helpers.localize(c.bill.maturity_date)}",
                                       "#{c.payment_date.nil? ? "Brak" : ActionController::Base.helpers.localize(c.payment_date)}",
                                       "#{c.agent.nil? ? "Brak" : c.agent.name}",
                                       "#{c.agent_date.nil? ? "Brak" : ActionController::Base.helpers.localize(c.agent_date)}"]
        end
      end
    end

    file = File.join(Rails.root, "tmp", "raport.csv")
    File.open(file, 'w:cp1250') do |f|
      f.write string.encode("cp1250")
    end
    file
  end

  #def self.countries_report_to_csv(clearings)
  #  string = CSV.generate(:col_sep => ";") do |csv|
  #    clearings.group_by(&:year).sort.each do |year, clearings_by_year|
  #      csv << ["Rok rozliczenia:", "#{year}"]
  #      clearings_by_year.group_by(&:month).sort.each do |month, clearings_by_month|
  #        csv << ["Miesiąc: #{month}", "Ilość rozliczeń: #{clearings_by_month.size}"]
  #      end
  #
  #      clearings_by_year.group_by(&:country).sort.each do |country, clearings_by_country|
  #        csv << ["Kraj:", "#{clearings_by_country.first.country.name}", "Ilość wystawionych rozliczeń dla kraju:", "#{clearings_by_country.size}"]
  #      end
  #    end
  #  end
  #
  #  file = File.join(Rails.root, "tmp", "raport.csv")
  #  File.open(file, 'w:cp1250') do |f|
  #    f.write string.encode("cp1250")
  #  end
  #  file
  #end

  def self.generate_pdf
    pdf = Prawn::Document.new(page_size: "A4", layout: :landscape)
    pdf.font_families.update("mine" => {
        :bold => "#{Rails.root}/app/assets/fonts/DejaVuSans-Bold.ttf",
        :italic => "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf",
        :bold_italic => "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf",
        :normal => "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"})
    pdf.font("mine")
    pdf.font_size 12

    yield pdf if block_given?

    string = "strona <page> / <total>"
    options = {:at => [pdf.bounds.right - 150, 0],
               :width => 150,
               :align => :right,
               :start_count_at => 1,
               :color => "007700"}
    pdf.number_pages string, options

    file = File.join(Rails.root, "tmp", "raport.pdf")
    pdf.render_file file

    file
  end
end