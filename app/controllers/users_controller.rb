class UsersController < ApplicationController
  
  def index
    @users = current_subdomain.nil? ? User.all : current_subdomain.users
  end

  def show
    @user = User.find(params[:id])
    if !current_subdomain.nil?
      check_my_subdomain(@user.subdomain.name)
    end
  end
  
  def valid
    token_user = User.valid?(params)
    if token_user
      sign_in(:user, token_user)
      flash[:notice] = "You have been logged in"
    else
      flash[:alert] = "Login could not be validated"
    end
    redirect_to :root
  end
end
