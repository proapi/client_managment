class Client < ActiveRecord::Base
  audited protect: false #, comment_required: true

  has_one :address
  has_one :forwarding_address, class_name: 'Address'
  belongs_to :user

  attr_accessible :birthdate, :description, :email, :firstname, :identifier, :lastname, :mobile, :telephone, :user_id, :address_attributes

  accepts_nested_attributes_for :address, :allow_destroy => true

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :birthdate, presence: true
  validates :identifier, presence: true
end
