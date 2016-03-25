class Like < ActiveRecord::Base

  belongs_to :user
  belongs_to :post

  after_create :increase_total_likes

  after_destroy :decrease_total_likes


  def increase_total_likes
    post.total_likes += 1
    post.save
  end

  def decrease_total_likes
    post.total_likes -= 1
    post.save
  end


end