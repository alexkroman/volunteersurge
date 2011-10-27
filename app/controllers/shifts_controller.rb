class ShiftsController < ApplicationController
  set_tab :shifts

  def index
    @shifts = ShiftReport.new(params[:shift_report])
    @assets = @shifts.assets.paginate(:page => params[:page])
  end

end
