class Company < ActiveRecord::Base
  has_and_belongs_to_many :addresses
  attr_accessible :name, :short, :tax_number, :addresses_attributes, :account_number, :bank_name
  accepts_nested_attributes_for :addresses, allow_destroy: false, reject_if: :all_blank

  validates :addresses, presence: true
  validates_presence_of :name, :short, :tax_number, :account_number, :bank_name, :bill_number

  before_create :set_bill_number

  def address
    addresses.first
  end

  def self.all_cached
    Rails.cache.fetch('Company.all') { all }
  end

  after_save :expire_all_cache
  after_destroy :expire_all_cache

  def expire_all_cache
    Rails.cache.delete('Company.all')
  end

  private
  def set_bill_number
    self.bill_number = 0 if self.bill_number.nil?
  end
end
