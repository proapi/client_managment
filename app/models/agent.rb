class Agent < ActiveRecord::Base
  attr_accessible :name

  validates_presence_of :name

  def self.all_cached
    Rails.cache.fetch('Agent.all') { all }
  end

  after_save    :expire_all_cache
  after_destroy :expire_all_cache

  def expire_all_cache
    Rails.cache.delete('Agent.all')
  end
end
