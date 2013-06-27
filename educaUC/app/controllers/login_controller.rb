# encoding: utf-8

class LoginController < ApplicationController

skip_before_filter :check_token

def index
	
end

def login
  user_name = params[:user]
	password = params[:password]
		
	user = User.find_by_email(user_name)
		
	if(user.nil?)
		redirect_to :login, notice: "email y/o contraseña incorrectos."
		return
	end
	
	salt = user.salt
	password = salt + password
		
	10.times do |x|
		password = Digest::SHA1.hexdigest(password)
	end

		
	if (user.active != 1)
		session[:user_id] = user.id
		redirect_to :login, notice: 'La cuenta se encuentra desactivada, para más detalles contacte a un administrador.'
		return
	elsif(user.hash_password!=password)
		redirect_to :login, notice: 'email y/o contraseña incorrectos.'
		return
	end
	session[:token] = user.generateToken
	redirect_to session[:original_url]
  end

def logout
    session[:token] = nil
    redirect_to :login, notice: 'Sesión cerrada exitosamente.'
end
end
