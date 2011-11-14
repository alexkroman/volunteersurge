class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    @signups = @user.signups
  end

  def valid
    token_user = User.valid?(params)
    if token_user
      sign_in(:user, token_user)
      flash[:notice] = "You have been logged in"
    else
      flash[:alert] = "Login could not be validated"
    end
    if token_user.admin?
      redirect_to dashboard_index_path
    else
      redirect_to :root
    end
  end
end
