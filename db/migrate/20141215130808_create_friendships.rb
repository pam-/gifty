class CreateFriendships < ActiveRecord::Migration
  def change
  	create_table :friendships do |t|
  		t.integer :user_id, null: false
  		t.integer :friend_id, null: false
  		t.string :status, null: false, default: ""
  	end
  end
end