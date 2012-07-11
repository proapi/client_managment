class Bill < ActiveRecord::Base
  belongs_to :clearing
  belongs_to :company
  belongs_to :user

  attr_accessible :clearing_id, :company_id, :commission_final, :commission_date, :exchange_rate, :maturity_date, :payment_date, :comment, :user_id

  validates_presence_of :clearing, :company_id, :commission_final, :user_id, :number
  before_validation :set_number

  def self.all_cached
    Rails.cache.fetch('Bill.all') { all }
  end

  after_save :expire_all_cache
  after_save :set_number_in_company
  after_destroy :expire_all_cache

  def expire_all_cache
    Rails.cache.delete('Bill.all')
  end

  private
  def set_number
    self.number="#{self.company.bill_number.to_i + 1}/#{self.company.short.upcase}"
  end

  def set_number_in_company
    self.company.update_attribute :bill_number, self.number.slice(/^[0-9]+/)
  end
end
