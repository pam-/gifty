class Friendship < ActiveRecord::Base
	belongs_to :user
	belongs_to :friend, class_name: "User"

def self.new_request(user, friend)
		sent = true
		unless user == friend || Friendship.exists?(user_id: user.id, friend_id: friend.id, status: "confirmed") || Friendship.exists?(user_id: user.id, friend_id: friend.id, status: "pending")
			friendship = user.friendships.new(friend_id: friend.id, status: "pending")
			if friendship.save
				sent = true
			else 
				sent = false
			end 
		end 
	end

	def self.confirm(user, friend)
		confirmed = true
		friendship = Friendship.find_by(user_id: user.id, friend_id: friend.id, status: 'pending')
		if friendship
			friendship.update_attribute(:status, 'confirmed')
			confirmed = true
		else 
			confirmed = false
		end 
	end	
end 