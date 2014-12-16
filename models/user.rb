class User < ActiveRecord::Base

	has_many :friendships, -> { where "friendships.status = 'confirmed'" }
	has_many :friends, through: :friendships, source: :friend

	# validations
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates :username,
    :presence => true,
    :length => { maximum: 255 }
  validates :email,
    :presence => true,
    :uniqueness => { case_sensitive: false },
    :length => { maximum: 255 },
    :format => { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }

  has_secure_password
end 