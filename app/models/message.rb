class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :client
  attr_accessible :body, :origin, :source, :client_id, :user_id
end