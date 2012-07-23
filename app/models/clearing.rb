class Clearing < ActiveRecord::Base
  audited protect: false #, comment_required: true

  belongs_to :client
  belongs_to :country
  belongs_to :user
  has_many :messages
  has_one :bill
  belongs_to :agent

  attr_accessible :bank_account, :bank_account_1, :bank_account_2, :bank_account_3, :on_clients_account, :country_id, :user_id, :agent_id, :client_id, :description, :application_date, :commission_currency, :commission_date, :commission_final, :commission_min, :commission_percent, :decision_date, :office_send_date, :rebate_calc, :rebate_final, :tax_number, :year, :archive, :exchange_rate, :income_date, :income_total, :income_exchange_rate, :total_to_client

  validates :year, presence: true
  validates :tax_number, presence: true
  validates :client_id, presence: true
  validates :user_id, presence: true
  validates :country_id, presence: true

  #def self.no_bill
  #  all(include: :bill).keep_if { |c| c.bill.nil? }
  #  #Clearing.includes(:bill).where(Bill.arel_table[:id].eq(nil))
  #end

  def self.undone
    #all(include: :bill).keep_if do |c|
    #  c.bill.nil? ? true : c.bill.payment_date.nil?
    #end
    where(archive: false)
  end

  def self.all_cached
    Rails.cache.fetch('Clearing.all') { all }
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
