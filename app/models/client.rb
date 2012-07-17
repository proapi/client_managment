#encoding: utf-8
class Client < ActiveRecord::Base
  audited protect: false #, comment_required: true

  has_one :address
  has_one :mailing_address, class_name: 'Address'
  belongs_to :user
  has_many :messages, through: :clearings
  has_many :clearings
  has_many :bills, through: :clearings

  attr_accessible :birthdate, :description, :email, :firstname, :lastname, :middlename, :mobile, :telephone, :user_id, :address_attributes, :mailing_address_attributes, :children_data, :married, :married_date, :married_data

  accepts_nested_attributes_for :address, :allow_destroy => true
  accepts_nested_attributes_for :mailing_address, :allow_destroy => true

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :birthdate, presence: true
  validates :identifier, presence: true
  validates_numericality_of :identifier
  validates_uniqueness_of :identifier

  before_validation :check_addresses
  before_validation :set_identifier

  def self.all_cached
    Rails.cache.fetch('Client.all') { all }
  end

  after_save :expire_all_cache
  after_destroy :expire_all_cache

  def expire_all_cache
    Rails.cache.delete('Client.all')
  end

  def get_married_description
    case self.married
      when 0
        return "Panna/Kawaler"
      when 1
        return "Mężatka/Żonaty"
      when 2
        return "Rozwodnik"
      when 3
        return "Wdowa/Wdowiec"
      else
        return "Nie rozpoznano wartości"
    end
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

  def set_identifier
    self.identifier=(Client.maximum(:identifier).to_i + 1).to_s if self.identifier.nil?
  end
end