class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  has_many :messages
  has_many :clients
  has_many :clearings
  has_many :enclosures
  belongs_to :company

  validates_presence_of :name, :email

  def self.all_cached
    Rails.cache.fetch('User.all') { all }
  end

  after_save    :expire_all_cache
  after_destroy :expire_all_cache

  def expire_all_cache
    Rails.cache.delete('User.all')
  end
end
