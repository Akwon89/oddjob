class AddPosts < ActiveRecord::Migration
  
  def change
    create_table :posts do |t|
      t.string :post_title
      t.string :location
      t.text :description
      t.date :date
      t.integer :user_id
      t.text :post_pic
      t.integer :total_likes, default: 0
      t.timestamps null: false
    end
  end
end