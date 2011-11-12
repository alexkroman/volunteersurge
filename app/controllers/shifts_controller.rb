class ShiftsController < ApplicationController
  def index
    @shifts = current_user.events.paginate(:page => params[:page]) if user_signed_in?
  end

end
