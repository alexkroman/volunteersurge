class VolunteerReportsController < ApplicationController

  def index
     @volunteers = VolunteerReport.new(params[:volunteer_report])
     @assets = @volunteers.assets.paginate(:page => params[:page])
  end
 
end