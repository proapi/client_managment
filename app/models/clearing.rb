class Clearing < ActiveRecord::Base
  audited protect: false #, comment_required: true

  belongs_to :client
  belongs_to :country
  belongs_to :user
  has_many :messages
  has_one :bill
  belongs_to :agent

  attr_accessible :bank_account_destination, :bank_account_data, :bank_account_number, :country_id, :user_id, :agent_id, :client_id, :description, :application_date, :commission_currency, :commission_date, :commission_final, :commission_min, :commission_percent, :decision_date, :office_send_date, :rebate_calc, :rebate_final, :tax_number, :year, :archive, :exchange_rate, :income_date, :income_total, :income_exchange_rate, :total_to_client, :agent_date, :payment_date, :bill_attributes, :bill_amount

  validates :year, presence: true
  validates :tax_number, presence: true
  validates :client_id, presence: true
  validates :user_id, presence: true
  validates :country_id, presence: true

  validates_presence_of :exchange_rate if self.commission_currency != 'PLN'

  accepts_nested_attributes_for :bill

  def self.undone
    where(archive: false)
  end

  def self.all_cached
    Rails.cache.fetch('Clearing.all') { all }
  end

  before_save :calc_commission

  def calc_commission
    if !self.rebate_final.nil? && self.rebate_final > 0
      if self.commission_percent == 0
        commission_calc = self.commission_min
      else
        if commission_currency == 'PLN'
          commission_calc = self.commission_percent/100 * self.rebate_final
        else
          commission_calc = self.commission_percent/100 * self.exchange_rate * self.rebate_final
        end
        if commission_calc < self.commission_min
          commission_calc = self.commission_min
        end
      end
      if commission_calc > 0 && self.commission_final.nil?
        self.commission_final = commission_calc
      end
    else
      self.commission_final = 0
    end
  end

  after_save :expire_all_cache
  after_destroy :expire_all_cache

  def expire_all_cache
    Rails.cache.delete('Clearing.all')
    Rails.cache.delete('Clearing.undone')
  end

  def title
    "#{self.client.lastname} #{self.client.firstname} / #{self.country.short} / #{self.year}"
  end
end
