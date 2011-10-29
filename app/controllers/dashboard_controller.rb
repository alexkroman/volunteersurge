class DashboardController < ApplicationController
  #load_and_authorize_resource

  def index
    @shifts = ShiftReport.new(:short => true)
    @volunteers = VolunteerReport.new(:short => true)
    @signups = current_subdomain.signups.limit(6)
  end

end
