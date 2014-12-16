class User < ActiveRecord::Base

	Sinatra::SimpleAuthentication.require_adapter

	include Sinatra::SimpleAuthentication::Models::ActiveRecord::Adapter

	has_many :friendships, -> { where "friendship.status = 'confirmed'" }
	has_many :friends, through: :friendships, source: :friend

	def self.new_request(user, friend)
		sent = true
		unless Friendship.exists?(user_id: user.id, friend_id: friend.id, status: "confirmed") || Friendship.exists?(user_id: user.id, friend_id: friend.id, status: "pending")
			frienship = user.friendships.new(friend_id: friend.id)
			if frienship.save
				sent = true
			else 
				sent = false
			end 
		end 
	end

	def self.confirm_request(user, friend)
		confirmed = true
		friendship = Friendship.exists?(user_id: user.id, friend_id: friend.id, status: 'pending')
		if frienship
			friendship.update_attribute(status: 'confirmed')
		else 
			confirmed = false
		end 
	end
end 