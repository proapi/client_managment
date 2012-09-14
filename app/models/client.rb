#encoding: utf-8
class Client < ActiveRecord::Base
  audited protect: false #, comment_required: true

  has_one :address, dependent: :destroy, conditions: ['kind = ?', 'address']
  has_one :mailing_address, class_name: 'Address', dependent: :destroy, conditions: ['kind = ?', 'mailing_address']
  belongs_to :user
  has_many :messages, through: :clearings
  has_many :clearings, dependent: :destroy
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
    Rails.cache.fetch('Client.all') { all(include: [:address, :mailing_address]).order('lastname') }
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
        return "Rozwiedziona/Rozwiedziony"
      when 3
        return "Wdowa/Wdowiec"
      else
        return "Nie rozpoznano wartości"
    end
  end

  def fullname
    self.lastname + ' ' + self.firstname
  end

  private
  def check_addresses
    if self.mailing_address.city.blank? && !self.address.city.blank?
      self.mailing_address.city = self.address.city
    end
    if self.mailing_address.street.blank? && !self.address.street.blank?
      self.mailing_address.street = self.address.street
    end
    if self.mailing_address.code.blank? && !self.address.code.blank?
      self.mailing_address.code = self.address.code
    end
  end

  def set_identifier
    self.identifier = (Client.maximum(:identifier) || 9999) + 1 if self.identifier.nil?
  end
end