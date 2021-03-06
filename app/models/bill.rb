#encoding: utf-8
require 'prawn'
#require 'numbers_and_words'

class Bill < ActiveRecord::Base
  belongs_to :clearing
  belongs_to :company
  belongs_to :user

  delegate :client, to: :clearing, allow_nil: true

  attr_accessible :clearing_id, :company_id, :total, :maturity_date, :issue_date, :comment, :user_id, :payment_form, :title, :units, :number, :total_manual, :number_manual, :currency

  validates_presence_of :clearing_id, :company_id, :user_id, :total, :issue_date, :maturity_date, :currency

  def self.all_cached
    Rails.cache.fetch('Bill.all') { Bill.includes([:company, {:clearing => [:client, :country]}]).order('number') }
  end

  after_save :expire_all_cache
  before_validation :set_number
  after_create :set_number_in_company
  after_destroy :expire_all_cache

  def expire_all_cache
    Rails.cache.delete('Bill.all')
  end

  def to_pdf
    pdf = Prawn::Document.new(:page_size => "A4")
    pdf.font_families.update("mine" => {
        :bold => "#{Rails.root}/app/assets/fonts/DejaVuSans-Bold.ttf",
        :italic => "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf",
        :bold_italic => "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf",
        :normal => "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"})
    pdf.font("mine")

    prepare_pdf pdf, "Oryginał"

    pdf.start_new_page

    prepare_pdf pdf, "Kopia"

    file = File.join(Rails.root, "tmp", "rachunek.pdf")
    pdf.render_file file

    file
  end

  private
  def prepare_pdf(pdf, original)
    pdf.font_size 9

    pdf.move_down 15

    pdf.text "#{self.company.address.city}, #{self.issue_date}", align: :right

    pdf.move_down 25

    pdf.font_size 12

    pdf.text "Rachunek nr: #{self.number}", style: :bold, align: :center
    pdf.text original, align: :center

    pdf.font_size 9

    pdf.move_down 25

    table_left = pdf.make_table([["#{self.company.name}"], [""], ["#{self.company.address.street}"], ["#{self.company.address.code} #{self.company.address.city}"], ["NIP #{self.company.tax_number}"]], width: 260, :cell_style => {:borders => [], align: :center})
    table_right = pdf.make_table([["#{self.clearing.client.fullname}"], [""], ["#{self.clearing.client.address.street}"], ["#{self.clearing.client.address.code} #{self.clearing.client.address.city}"]], width: 260, :cell_style => {:borders => [], align: :center})
    cell_header_left = pdf.make_cell(content: "<b>Sprzedawca</b>", inline_format: true, align: :center)
    cell_header_right = pdf.make_cell(content: "<b>Nabywca</b>", inline_format: true, align: :center)
    table_data = [[cell_header_left, cell_header_right], [table_left, table_right]]
    pdf.table(table_data, header: true, width: 520, position: :center)

    pdf.move_down 25

    table_left = pdf.make_table([["Data sprzedaży: #{helpers.localize(self.issue_date)}"], ["Termin zapłaty: #{helpers.localize(self.maturity_date)}"], ["Sposób zapłaty: #{self.payment_form}"]], width: 260, :cell_style => {:borders => [], align: :left})

    if self.payment_form.eql? 'Przelew'
      table_right = pdf.make_table([["Bank: #{self.company.bank_name}"], ["Numer konta: #{self.company.account_number}"], [""]], width: 260, :cell_style => {:borders => [], align: :left})
    else
      table_right = pdf.make_table([[""], [""], [""]], width: 260, :cell_style => {:borders => [], align: :left})
    end

    pdf.table([[table_left, table_right]], width: 520, position: :center, :cell_style => {:borders => []})

    pdf.move_down 25

    table_data = [[pdf.make_cell(content: "<b>Lp.</b>", inline_format: true), pdf.make_cell(content: "<b>Nazwa towaru / usługi</b>", inline_format: true), pdf.make_cell(content: "<b>Ilość</b>", inline_format: true), pdf.make_cell(content: "<b>Jedn. miary</b>", inline_format: true), pdf.make_cell(content: "<b>Cena jednostki</b>", inline_format: true), pdf.make_cell(content: "<b>Wartość</b>", inline_format: true)],
                  [pdf.make_cell(content: "1"), pdf.make_cell(content: "#{self.title}"), pdf.make_cell(content: "1"), pdf.make_cell(content: "#{self.units}"), pdf.make_cell(content: "#{helpers.number_with_precision(self.total, precision: 2, delimiter: " ")}"), pdf.make_cell(content: "#{helpers.number_with_precision(self.total, precision: 2, delimiter: " ")}")]]
    pdf.table(table_data, header: true, width: 520, position: :center)

    pdf.move_down 25

    if self.comment && !self.comment.empty?
      pdf.text "Adnotacje:", style: :bold_italic, align: :left
      pdf.text "#{self.comment}", style: :italic, align: :left
    end

    pdf.move_down 45

    pdf.text "Do zapłaty: #{helpers.number_with_precision(self.total, precision: 2, delimiter: " ")} #{self.currency}", style: :bold

    pdf.move_down 25

    pdf.text "Słownie: #{price_to_words(helpers.number_with_precision(self.total, precision: 2, delimiter: " "), self.currency)}"

    pdf.move_down 90

    pdf.table([[pdf.make_cell(content: "podpis odbiorcy", align: :center, :borders => []), pdf.make_cell(content: "podpis wystawcy", align: :center, :borders => [])]], header: true, width: 520, position: :center)
  end

  def helpers
    ActionController::Base.helpers
  end

  def set_number
    self.number = "#{self.company.bill_number.to_i + 1}/#{Date.current.year}" if self.number.blank?
    self.number = self.number.insert(0, '0') if self.number.to_s.size < 7
    self.number = self.number.insert(0, '0') if self.number.to_s.size < 8
  end

  def set_number_in_company
    unless self.number_manual
      self.company.update_attribute :bill_number, (self.company.bill_number.to_i + 1)
    end
  end

  def price_to_words(price, currency)
    hash = %w(zer jed dwa trz czt pię sze sie osi dzi)
    str = ""
    grosze = false
    price.to_s.each_char do |s|
      if s.eql? ","
        grosze = true
        str += "zł*" if currency.eql? 'PLN'
        str += "EURO*" if currency.eql? 'EURO'
      else
        if grosze
          str += "#{s}"
        else
          str += "#{hash[s.to_i]}*"
        end
      end
    end
    str += "/100"
  end
end
