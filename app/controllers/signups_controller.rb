class SignupsController < ApplicationController
  
  def index
    @signups = current_user.signups.paginate(params[:page]) if user_signed_in?
  end
  
end
