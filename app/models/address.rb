class Address < ActiveRecord::Base
  audited protect: false
  belongs_to :client
  has_and_belongs_to_many :companies
  attr_accessible :city, :code, :street, :kind
  validates :city, :presence => true
  validates :code, :presence => true
  validates :street, :presence => true

  def self.all_cached
    Rails.cache.fetch('Address.all') { all }
  end

  after_save    :expire_all_cache
  after_destroy :expire_all_cache

  def expire_all_cache
    Rails.cache.delete('Address.all')
  end

end
