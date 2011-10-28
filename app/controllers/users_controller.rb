class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
  end
  
  def index
     @volunteers = VolunteerReport.new(params[:volunteer_report])
     @assets = @volunteers.assets.paginate(:page => params[:page])
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
