class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :clearing
  attr_accessible :body, :origin, :source, :clearing_id, :user_id

  def self.all_cached
    Rails.cache.fetch('Message.all') { all }
  end

  after_save :expire_all_cache
  after_destroy :expire_all_cache

  def expire_all_cache
    Rails.cache.delete('Message.all')
  end

  def self.expire_all_cache
    Rails.cache.delete('Message.all')
  end
end
