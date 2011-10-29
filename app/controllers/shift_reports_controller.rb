class ShiftReportsController < ApplicationController

  def index
     @shifts = ShiftReport.new(params[:shift_report])
     @assets = @shifts.assets.paginate(:page => params[:page], :per_page => 10)
  end
 
end