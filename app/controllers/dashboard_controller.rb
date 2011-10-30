class DashboardController < ApplicationController
  #load_and_authorize_resource

  def index
    @shifts = current_subdomain.events.order(:starttime).limit(6)
    @users = current_subdomain.users.order('created_at desc').limit(6)
    @signups = current_subdomain.signups.order('created_at desc').limit(6)
    @events = current_subdomain.events.order('created_at desc').limit(6)
  end

end
