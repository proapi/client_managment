class Clearing < ActiveRecord::Base
  audited protect: false #, comment_required: true

  belongs_to :client
  belongs_to :country
  belongs_to :user
  has_many :messages, dependent: :destroy
  has_one :bill, dependent: :destroy
  belongs_to :agent

  attr_accessible :bank_account_destination, :bank_account_data, :bank_account_number, :country_id, :user_id, :agent_id, :client_id, :description, :application_date, :commission_currency, :commission_date, :commission_final, :commission_min, :commission_percent, :decision_date, :office_send_date, :rebate_calc, :rebate_final, :tax_number, :year, :archive, :exchange_rate, :income_date, :income_total, :income_exchange_rate, :total_to_client, :agent_date, :payment_date, :bill_attributes, :bill_amount, :to_client_date, :commission_manual, :internet_send_date

  validates :year, presence: true
  validates :tax_number, presence: true
  validates :client_id, presence: true
  validates :user_id, presence: true
  validates :country_id, presence: true

  #validates_presence_of :exchange_rate if self.commission_currency != 'PLN'

  accepts_nested_attributes_for :bill

  def self.undone
    where(archive: false)
  end

  def self.all_cached
    Rails.cache.fetch('Clearing.all') { all }
  end

  def self.without_bill
    all(include: :bill).keep_if { |c| c.bill.nil? }
  end

  def self.generate_final_rebates
    result = ''
    without_bill.each do |clearing|
      result += clearing.id.to_s + '=' + clearing.rebate_final.to_s + ';' unless clearing.rebate_final.nil?
    end
    result
  end

  #before_save :calc_commission

  #
  # pamiętać o ręcznym wpisaniu do rozliczenia prowizji końcowej
  #
  #def calc_commission
  #  if !self.rebate_final.nil? && self.rebate_final > 0
  #
  #    if commission_currency == 'PLN'
  #      self.exchange_rate = 1
  #    end
  #
  #    commission_calc = self.commission_min * self.exchange_rate
  #
  #    if self.commission_percent > 0
  #      commission_calc_temp = self.commission_percent/100.00 * self.exchange_rate * self.rebate_final
  #      commission_calc = commission_calc_temp if commission_calc_temp > commission_calc
  #    end
  #
  #    if commission_calc > 0 && commission_final.nil?
  #      self.commission_final = commission_calc
  #    else
  #      #commission_final pozostaje bez zmian
  #    end
  #  else
  #    self.commission_final = 0
  #  end
  #end

  after_save :expire_all_cache
  after_destroy :expire_all_cache

  def expire_all_cache
    Rails.cache.delete('Clearing.all')
    Rails.cache.delete('Clearing.undone')
  end

  def title
    unless client.nil?
      "#{self.client.lastname} #{self.client.firstname} / #{self.country.short} / #{self.year}"
    else
      'Brak'
    end
  end

end
