class Bill < ActiveRecord::Base
  belongs_to :clearing
  belongs_to :company
  # attr_accessible :title, :body
end
