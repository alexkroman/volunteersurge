class ShiftsController < ApplicationController
  def index
    @shifts = current_user.events.paginate(:page => params[:page])
  end

end
