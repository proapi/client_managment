class Country < ActiveRecord::Base
  attr_accessible :currency, :name, :short
  has_many :documents
end
