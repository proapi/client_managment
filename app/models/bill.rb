class Bill < ActiveRecord::Base
  belongs_to :clearing
  belongs_to :company
  # attr_accessible :title, :body

  def self.all_cached
    Rails.cache.fetch('Bill.all') { all }
  end

  after_save    :expire_all_cache
  after_destroy :expire_all_cache

  def expire_all_cache
    Rails.cache.delete('Bill.all')
  end
end
