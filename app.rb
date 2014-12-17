require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/reloader'
require 'pry'

require_relative './models/user'
require_relative './models/friendship'
# binding.pry

enable :sessions

helpers do
  def current_user
    @current_user || nil
  end

  def current_user?
    @current_user == nil ? false : true
  end

  def user_signed_in?
  	session[:user_id]
  end
end

before do
  session[:cart] ||= []
  @errors ||= []
  @current_user = User.find_by(:id => session[:user_id])
end

def authenticate_user
	redirect '/login' unless user_signed_in?
end

get '/' do
	@users = User.all
	erb :index
end

get '/users/:id' do
	authenticate_user
	@user = User.find(params[:id])
	@friends = @user.friends.include?(current_user)
	@pending = Friendship.exists?(user_id: current_user.id, friend_id: @user.id, status: 'pending')
	@friended = Friendship.exists?(user_id: @user.id, friend_id: current_user.id, status: 'pending')
	erb :user_show
end 

post '/new_request' do
	@user = current_user
	@friend = User.find(params[:friend_id])
	@new_request = Friendship.new_request(@user, @friend)
	if @new_request
		@success_message = "Yay! Friendship request sent!!"
		redirect "/users/#{@friend.id}"
	else
		@error_message = ":( nope.."
		redirect "/users/#{@friend.id}"
	end 
end

put '/confirm' do
	@user = User.find(params[:user_id])
	@friend = current_user
	@confirmation = Friendship.confirm(@user, @friend)
	if @confirmation
		redirect "/"
	else
		redirect "users/#{@user.id}"
	end 
end

get '/login' do
  erb :login
end

post "/login" do
  user = User.find_by(:email => params[:email])
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect('/')
  else
    @errors << "Invalid email or password. Try again!"
    erb :login
  end
end

get '/sign_up' do
  erb :sign_up
end

get '/update' do
  erb :update
end 

post "/sign_up" do
  upload(params[:content]['file'][:filename], params[:content]['file'][:tempfile])
  user = User.new(params)
  if user.save
    session[:user_id] = user.id
    redirect('/')
  else
    @user = user
    erb :sign_up
  end
end

post '/users/update' do
  upload(params[:content]['file'][:filename], params[:content]['file'][:tempfile])
  if current_user.update_attributes(params)
    redirect "/users/#{current_user.id}"
  else
    redirect '/update'
  end 
end

get "/logout" do
  session.clear
  redirect('/')
end
