class User < ActiveRecord::Base

  has_many :likes
  has_many :posts
  has_one :userpic
  
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :username, presence: true
  validates :email, presence: true

end