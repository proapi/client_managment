class Clearing < ActiveRecord::Base
  belongs_to :client
  belongs_to :country
  belongs_to :user

  attr_accessible :country_id, :user_id, :client_id, :description, :account_number, :application_date, :commission_currency, :commission_date, :commission_final, :commission_min, :commission_percent, :decision_date, :exchange_rate, :maturity_date, :office_send_date, :payment_date, :rebate_calc, :rebate_final, :tax_number, :year

  #validates :year, presence: true
  #validates :tax_number, presence: true
  #validates :client_id, presence: true
  #validates :user_id, presence: true
  #validates :country_id, presence: true

  def self.all_cached
    Rails.cache.fetch('Clearing.all') { all }
  end

  after_save    :expire_all_cache
  after_destroy :expire_all_cache

  def expire_all_cache
    Rails.cache.delete('Clearing.all')
  end
end
