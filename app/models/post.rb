class Post < ActiveRecord::Base

  belongs_to :user
  has_one :postpic
  has_many :likes

  
  validates :post_title, presence: true
  validates :location, presence: true
  validates :description, presence: true
  validates :user_id, presence: true
  validates :date, presence: true

end