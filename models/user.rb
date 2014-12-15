class User < ActiveRecord::Base
	has_many :friendships
	has_many :friends, through: :friendships, -> { where "friendship.status = 'confirmed'" }

	
end 