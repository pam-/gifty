require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/simple-authentication'

require_relative './models/user'

register Sinatra::SimpleAuthentication


get '/' do
	login_required
	@users = User.all
	erb :index
end

post 'new_request' do
	@user = current_user
	@friend = User.find(params[:friend_id])
	@request = User.new_request(@user, @friend)
	if @request
		redirect "/users/#{@user.id}"
	else
		render 'new'
	end 
end


