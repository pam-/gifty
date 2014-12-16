class CreateUsers < ActiveRecord::Migration
  def change
  	create_table :users do |t|
	  	t.string :username
	  	t.string :email
	  	t.string :bio
	  	t.string :hashed_password
	  	t.string :salt
	  end 
  end
end
