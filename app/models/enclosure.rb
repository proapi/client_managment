class Enclosure < ActiveRecord::Base
  belongs_to :user
  belongs_to :clearing

  attr_accessible :description, :name, :user_id, :clearing_id, :attachment

  has_attached_file :attachment

  validates :name, :presence => true
  validates :clearing_id, :presence => true
  validates :user_id, :presence => true
  validates_attachment :attachment, :presence => true, :size => { :in => 0..8000.kilobytes }

  def self.all_cached
    Rails.cache.fetch('Enclosure.all') { all }
  end

  after_save :expire_all_cache
  after_destroy :expire_all_cache

  def expire_all_cache
    Rails.cache.delete('Enclosure.all')
  end
end
