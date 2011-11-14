class SignupsController < ApplicationController
  authorize_resource
  
  def create
    @event = Event.find(params[:signup][:event_id])
    user = params[:signup][:user_to_signup] ? User.find_by_name(params[:signup][:user_to_signup]) : current_user
    Signup.create!(:number_attending => params[:signup][:number_attending], :event => @event, :event_series => @event.event_series, :user => user, :description => params[:signup][:description])
    respond_to do |format|
      format.html { redirect_to complete_event_path(@event) }
    end
  end

  def destroy
    @signup = Signup.find(params[:id])
    @signup.destroy
    respond_to do |format|
      format.html { redirect_to @signup.event }
    end
  end
end
