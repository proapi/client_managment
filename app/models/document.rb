class Document < ActiveRecord::Base
  belongs_to :country
  attr_accessible :body, :title, :country_id

  validates_presence_of :title, :country_id

  def self.all_cached
    Rails.cache.fetch('Document.all') { all }
  end

  after_save    :expire_all_cache
  after_destroy :expire_all_cache

  def expire_all_cache
    Rails.cache.delete('Document.all')
  end
end
