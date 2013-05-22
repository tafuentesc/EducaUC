class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details


  before_filter :check_token 

  protected

  def check_token
    if(session[:token]!=nil)
      @logged_user = User.find_by_token(session[:token])

      if(@logged_user==nil)
        session[:original_url] = request.url
        redirect_to :login
      end
    else
        session[:original_url] = request.url
        redirect_to :login
    end
  end


end