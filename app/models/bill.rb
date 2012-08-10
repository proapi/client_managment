class Bill < ActiveRecord::Base
  belongs_to :clearing
  belongs_to :company
  belongs_to :user

  attr_accessible :clearing_id, :company_id, :total, :maturity_date, :issue_date, :comment, :user_id, :payment_form, :title, :units

  validates_presence_of :clearing, :company_id, :user_id, :number, :total
  before_validation :set_number

  def self.all_cached
    Rails.cache.fetch('Bill.all') { all }
  end

  after_save :expire_all_cache
  after_create :set_number_in_company
  after_destroy :expire_all_cache

  def expire_all_cache
    Rails.cache.delete('Bill.all')
  end

  private
  def set_number
    self.number="#{self.company.bill_number.to_i + 1}/#{self.company.short.upcase}" if self.number.empty?
  end

  def set_number_in_company
    self.company.update_attribute :bill_number, self.number.slice(/^[0-9]+/)
  end
end
