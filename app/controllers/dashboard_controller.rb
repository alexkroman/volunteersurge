class DashboardController < ApplicationController
  #load_and_authorize_resource
  set_tab :dashboard

  def index
    @shifts = ShiftReport.new(:short => true)
    @assets = @shifts.assets
    
    @signups = current_subdomain.signups.order('created_at desc').limit(6)
    @users = current_subdomain.users.order('created_at desc').limit(6)
  end

end
