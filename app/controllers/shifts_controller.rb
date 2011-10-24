class ShiftsController < ApplicationController
  set_tab :shifts

  def index
    @shifts = current_subdomain.events.upcoming.paginate(:page => params[:page])
  end

end
