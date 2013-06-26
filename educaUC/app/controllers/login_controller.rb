class LoginController < ApplicationController

skip_before_filter :check_token

def index
	
end

def login
  user_name = params[:user]
	password = params[:password]
		
	user = User.find_by_email(user_name)
		
	if(user.nil?)
		redirect_to :login, notice: 'bad dataaaa'
		return
	end
		
	salt = user.salt
	password = salt + password
		
	10.times do |x|
		password = Digest::SHA1.hexdigest(password)
	end

		
	if(user.hash_password!=password)
		redirect_to :login, notice: 'bad dataaaa'
		return
	end
	session[:token] = user.generateToken
	redirect_to session[:original_url]
  end

def logout
    session[:token] = nil
    redirect_to :login, notice: 'Logged out.'
end
end
