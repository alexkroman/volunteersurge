class SignupsController < ApplicationController
  
  def index
    @signups = current_user.signups
  end
  
end
