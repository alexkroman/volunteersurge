class SignupsController < ApplicationController

  def index
    @signups = current_subdomain.signups.order('created_at desc').paginate(:page => params[:page])
  end

end
