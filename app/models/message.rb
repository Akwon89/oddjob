class Message < ActiveRecord::Base

  validates :recipient_id, presence: true
  validates :sender_id, presence: true
  validates :subject, presence: true
  validates :text, presence: true

end