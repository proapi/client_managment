class Document < ActiveRecord::Base
  belongs_to :country
  attr_accessible :body, :title, :country_id
end
