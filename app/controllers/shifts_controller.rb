class ShiftsController < ApplicationController
  def index
    @signups = current_user.signups.paginate(:page => params[:page]) 
  end

end
