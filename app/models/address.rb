class Address < ActiveRecord::Base
  audited protect: false
  belongs_to :client
  has_and_belongs_to_many :companies
  attr_accessible :city, :code, :street, :kind
  validates :city, :presence => true
  validates :code, :presence => true
  validates :street, :presence => true
end
