#encoding: utf-8
require 'prawn'

class Bill < ActiveRecord::Base
  belongs_to :clearing
  belongs_to :company
  belongs_to :user

  attr_accessible :clearing_id, :company_id, :total, :maturity_date, :issue_date, :comment, :user_id, :payment_form, :title, :units, :number, :total_manual

  validates_presence_of :clearing, :company_id, :user_id, :total, :issue_date, :maturity_date

  def self.all_cached
    Rails.cache.fetch('Bill.all') { all }
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
    pdf.font("#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf")
    pdf.font_size 9

    pdf.text "To jest przykładowy tekst"
    pdf.move_down 5

    string = "strona <page> / <total>"
    options = {:at => [pdf.bounds.right - 150, 0],
               :width => 150,
               :align => :right,
               :start_count_at => 1,
               :color => "007700"}
    pdf.number_pages string, options

    file = File.join(Rails.root, "tmp", "rachunek.pdf")
    pdf.render_file file

    file
  end

  private
  def set_number
    self.number="#{self.company.bill_number.to_i + 1}/#{self.company.short.upcase}" if self.number.blank?
  end

  def set_number_in_company
    self.company.update_attribute :bill_number, (self.company.bill_number.to_i + 1)
  end
end
