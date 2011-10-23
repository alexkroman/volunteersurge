class DashboardController < ApplicationController
  #load_and_authorize_resource

  def index
    @next_shifts = current_subdomain.events.order('starttime asc').limit(10)
    @signups = current_subdomain.signups.order('created_at desc').limit(10)
    @users = current_subdomain.users.order('created_at desc').limit(10)
  end

end
