class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :client
  attr_accessible :body, :origin, :source, :client_id, :user_id

  def self.all_cached
    Rails.cache.fetch('Message.all') { all }
  end

  after_save    :expire_all_cache
  after_destroy :expire_all_cache

  def expire_all_cache
    Rails.cache.delete('Message.all')
  end
end
