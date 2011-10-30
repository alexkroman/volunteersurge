class VolunteersController < ApplicationController
  
  def index
    @volunteers = User.paginate(:page => params[:page])
    respond_to do |format|
      format.html
    end
  end

  def search
    @volunteers = User.search_for(params[:search]).paginate(:page => params[:page])
    respond_to do |format|
      format.html {render :partial => 'table', :layout => false}
    end
  end
end
