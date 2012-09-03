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

  def self.generate_final_commissions
    result = ''
    without_bill.each do |clearing|
      result += clearing.id.to_s + '=' + clearing.commission_final.to_s + ';' unless clearing.commission_final.nil?
    end
    result
  end

  def month
    self.application_date.strftime('%m')
  end

  after_save :expire_all_cache
  after_destroy :expire_all_cache

  def expire_all_cache
    Rails.cache.delete('Clearing.all')
    Rails.cache.delete('Clearing.undone')
  end

  def title
    if client.nil?
      'Brak'
    else
      "#{self.client.lastname} #{self.client.firstname} / #{self.country.short} / #{self.year}"
    end
  end

end