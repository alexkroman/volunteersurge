class DashboardController < ApplicationController
  #load_and_authorize_resource

  def index
    @shifts = current_subdomain.events.order(:starttime).limit(6)
    @users = current_subdomain.users.limit(6)
    @signups = current_subdomain.signups.limit(6)
  end

end
