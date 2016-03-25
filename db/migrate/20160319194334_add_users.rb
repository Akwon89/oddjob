class AddUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :password
      t.string :email
      t.string :location
      t.text :about_you
      t.text :user_pic

      t.timestamps
    end
  end
end
