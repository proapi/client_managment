class Company < ActiveRecord::Base
  has_and_belongs_to_many :addresses
  attr_accessible :name, :short, :tax_number, :addresses_attributes
  accepts_nested_attributes_for :addresses, allow_destroy: false, reject_if: :all_blank

  validates :addresses, presence: true

  def address
    addresses.first
  end
end
