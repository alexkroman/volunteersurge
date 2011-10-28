class DashboardController < ApplicationController
  #load_and_authorize_resource

  def index
    @shifts = ShiftReport.new(:short => true)
    @volunteers = VolunteerReport.new(:short => true)
    @signups = SignupReport.new(:short => true)
  end

end
