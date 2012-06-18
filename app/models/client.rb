class Client < ActiveRecord::Base
  audited protect: false #, comment_required: true

  has_one :address
  has_one :mailing_address, class_name: 'Address'
  belongs_to :user
  has_many :messages
  has_many :clearings

  attr_accessible :birthdate, :description, :email, :firstname, :identifier, :lastname, :mobile, :telephone, :user_id, :address_attributes, :mailing_address_attributes

  accepts_nested_attributes_for :address, :allow_destroy => true
  accepts_nested_attributes_for :mailing_address, :allow_destroy => true

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :birthdate, presence: true
  validates :identifier, presence: true

  before_validation :check_addresses

  def self.all_cached
    Rails.cache.fetch('Client.all') { all }
  end

  after_save    :expire_all_cache
  after_destroy :expire_all_cache

  def expire_all_cache
    Rails.cache.delete('Client.all')
  end

  private
  def check_addresses
    if mailing_address.city.blank? && !address.city.blank?
      mailing_address.city = address.city
    end
    if mailing_address.street.blank? && !address.street.blank?
      mailing_address.street = address.street
    end
    if mailing_address.code.blank? && !address.code.blank?
      mailing_address.code = address.code
    end
  end
end
