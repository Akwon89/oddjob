class AddMessages < ActiveRecord::Migration
  
  def change
    create_table :messages do |t|
      t.integer :recipient_id
      t.integer :sender_id
      # t.references :post
      t.integer :post_id
      t.string :subject
      t.string :text
      t.timestamps null: false
    end
  end
end