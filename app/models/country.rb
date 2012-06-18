class Country < ActiveRecord::Base
  attr_accessible :currency, :name, :short
  has_many :documents

  def self.all_cached
    Rails.cache.fetch('Country.all') { all }
  end

  after_save    :expire_all_cache
  after_destroy :expire_all_cache

  def expire_all_cache
    Rails.cache.delete('Country.all')
  end
end
