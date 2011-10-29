class VolunteerReportsController < ApplicationController

  def index
     @report = params[:volunteer_report]
     @volunteers = VolunteerReport.new(@report)
     @assets = @volunteers.assets.paginate(:page => params[:page])
  end
 
end