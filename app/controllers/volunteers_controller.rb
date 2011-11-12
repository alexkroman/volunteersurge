class VolunteersController < ApplicationController
  
  def new
    @user = User.new
    respond_to do |format|
      format.js
    end
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.js { render :nothing => true }
      else
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def index
    @volunteers = User.search_for(params[:live_search]).paginate(:page => params[:page])
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
