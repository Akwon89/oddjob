class Post < ActiveRecord::Base

  belongs_to :user
  has_one :postpic
  has_many :likes

  
  validates :post_title, presence: true
  validates :location, presence: true
  validates :description, presence: true
  validates :user_id, presence: true
  validates :date, presence: true

  validate :task_date_cannot_be_in_the_past

  def task_date_cannot_be_in_the_past
    if date.present? && date < Date.today
      errors.add(:task_date, "can't be in the past")
    end
  end    
  

end