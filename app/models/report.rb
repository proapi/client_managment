#encoding: utf-8
require 'prawn'
require 'csv'

class Report
  def self.bills_report_to_pdf(bills)
    generate_pdf do |pdf|
      pdf.text "Raport rachunków", style: :bold

      pdf.font_size 9

      pdf.move_down 15

      table_data = Array.new
      table_data << ["Nazwisko", "Imię", "Numer rachunku", "Kwota z rachunku", "Kwota zapłacona", "Różnica kwot", "Data zapłaty"]
      bills.each do |bill|
        table_data << ["#{bill.clearing.client.lastname}", "#{bill.clearing.client.firstname}", "#{bill.number}", "#{ActionController::Base.helpers.number_with_precision(bill.total, precision: 2, delimiter: " ")}", "#{bill.clearing.to_client_date.nil? ? '' : ActionController::Base.helpers.number_with_precision(bill.total, precision: 2, delimiter: " ")}", "#{bill.clearing.to_client_date.nil? ? '' : 0}", "#{bill.clearing.payment_date.nil? ? '' : ActionController::Base.helpers.localize(bill.clearing.payment_date)}"]
      end
      pdf.table(table_data, header: true, width: 520, position: :center)
    end
  end

  def self.clearings_report_to_pdf(clearings)
    generate_pdf do |pdf|
      pdf.text "Raport rozliczeń w danym roku dla agenta", style: :bold

      pdf.font_size 9

      pdf.move_down 15

      clearings.group_by(&:year).sort.each do |year, clearings_by_year|
        pdf.text "Rok wystawienia rozliczenia: #{year}"
        clearings_by_year.group_by(&:agent).sort.each do |agent, clearings_by_agent|
          pdf.text "Nazwa agenta: #{agent.nil? ? "Brak" : agent.name}"
          pdf.move_down 5
          table_data = Array.new
          table_data << ["Nazwisko", "Imię", "Identyfikator", "Kraj", "Rok", "Numer podatkowy", "Wyliczona kota zwrotu", "Data wysłania do urzędu", "Data rozliczenia z agentem"]
          clearings_by_agent.each do |c|
            table_data << ["#{c.client.nil? ? "Brak" : c.client.lastname}", "#{c.client.nil? ? "Brak" : c.client.firstname}", "#{c.client.nil? ? "Brak" : c.client.identifier}", "#{c.country.nil? ? "Brak" : c.country.name}", "#{c.year}", "#{c.tax_number}", "#{c.rebate_calc.nil? ? "Brak" : ActionController::Base.helpers.number_with_precision(c.rebate_calc, precision: 2, delimiter: " ")}", "#{c.office_send_date.nil? ? "Brak" : ActionController::Base.helpers.localize(c.office_send_date)}", "#{c.agent_date.nil? ? "Brak" : ActionController::Base.helpers.localize(c.agent_date)}"]
          end
          pdf.table(table_data, header: true, width: 520, position: :center, :cell_style => {:size => 6})
          pdf.move_down 10
        end
      end
    end
  end

  def self.countries_report_to_pdf(clearings)
    generate_pdf do |pdf|
      pdf.text "Raport rozliczeń w danym roku", style: :bold

      pdf.font_size 9

      pdf.move_down 10

      clearings.group_by(&:year).sort.each do |year, clearings_by_year|
        pdf.move_down 15
        pdf.text "Rok rozliczenia: <b>#{year}</b>", inline_format: true
        clearings_by_year.group_by(&:month).sort.each do |month, clearings_by_month|
          pdf.text "Miesiąc: <b>#{month}</b> Ilość rozliczeń: <b>#{clearings_by_month.size}</b>", inline_format: true
        end
        pdf.move_down 15

        clearings_by_year.group_by(&:country).sort.each do |country, clearings_by_country|
          pdf.text "Kraj: <b>#{clearings_by_country.first.country.name}</b> Ilość wystawionych rozliczeń dla kraju: <b>#{clearings_by_country.size}</b>", inline_format: true
        end
      end
    end
  end

  def self.bills_report_to_csv(bills)
    string = CSV.generate do |csv|
      csv << ["Nazwisko", "Imię", "Numer rachunku", "Kwota z rachunku", "Kwota zapłacona", "Różnica kwot", "Data zapłaty"]
      bills.each do |bill|
        csv << ["#{bill.clearing.client.lastname}", "#{bill.clearing.client.firstname}", "#{bill.number}", "#{ActionController::Base.helpers.number_with_precision(bill.total, precision: 2, delimiter: " ")}", "#{bill.clearing.to_client_date.nil? ? '' : ActionController::Base.helpers.number_with_precision(bill.total, precision: 2, delimiter: " ")}", "#{bill.clearing.to_client_date.nil? ? '' : 0}", "#{bill.clearing.payment_date.nil? ? '' : ActionController::Base.helpers.localize(bill.clearing.payment_date)}"]
      end
    end

    file = File.join(Rails.root, "tmp", "raport.csv")
    File.open(file, 'w') do |f|
      f.write string
    end
    file
  end

  def self.clearings_report_to_csv(clearings)
    string = CSV.generate do |csv|
      clearings.group_by(&:year).sort.each do |year, clearings_by_year|
        csv << ["Rok wystawienia rozliczenia:", "#{year}"]
        clearings_by_year.group_by(&:agent).sort.each do |agent, clearings_by_agent|
          csv << ["Nazwa agenta:", "#{agent.nil? ? "Brak" : agent.name}"]
          csv << ["Nazwisko", "Imię", "Identyfikator", "Kraj", "Rok", "Numer podatkowy", "Wyliczona kota zwrotu", "Data wysłania do urzędu", "Data rozliczenia z agentem"]
          clearings_by_agent.each do |c|
            csv << ["#{c.client.nil? ? "Brak" : c.client.lastname}", "#{c.client.nil? ? "Brak" : c.client.firstname}", "#{c.client.nil? ? "Brak" : c.client.identifier}", "#{c.country.nil? ? "Brak" : c.country.name}", "#{c.year}", "#{c.tax_number}", "#{c.rebate_calc.nil? ? "Brak" : ActionController::Base.helpers.number_with_precision(c.rebate_calc, precision: 2, delimiter: " ")}", "#{c.office_send_date.nil? ? "Brak" : ActionController::Base.helpers.localize(c.office_send_date)}", "#{c.agent_date.nil? ? "Brak" : ActionController::Base.helpers.localize(c.agent_date)}"]
          end
        end
      end
    end

    file = File.join(Rails.root, "tmp", "raport.csv")
    File.open(file, 'w') do |f|
      f.write string
    end
    file
  end

  def self.countries_report_to_csv(clearings)
    string = CSV.generate do |csv|
      clearings.group_by(&:year).sort.each do |year, clearings_by_year|
        csv << ["Rok rozliczenia:", "#{year}"]
        clearings_by_year.group_by(&:month).sort.each do |month, clearings_by_month|
          csv << ["Miesiąc: #{month}", "Ilość rozliczeń: #{clearings_by_month.size}"]
        end

        clearings_by_year.group_by(&:country).sort.each do |country, clearings_by_country|
          csv << ["Kraj:", "#{clearings_by_country.first.country.name}", "Ilość wystawionych rozliczeń dla kraju:", "#{clearings_by_country.size}"]
        end
      end
    end

    file = File.join(Rails.root, "tmp", "raport.csv")
    File.open(file, 'w') do |f|
      f.write string
    end
    file
  end

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