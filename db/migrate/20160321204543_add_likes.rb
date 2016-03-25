class AddLikes < ActiveRecord::Migration
  def change 
    create_table :likes do |t|
      t.references :user
      t.references :post
    end
  end
end