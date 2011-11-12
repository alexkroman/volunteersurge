class SignupsController < ApplicationController
  def create
    @event = Event.find(params[:event_id])
    Signup.create!(:event => @event, :event_series => @event.event_series, :user => current_user)
    respond_to do |format|
      format.html { redirect_to @event }
    end
  end

  def destroy
    @event = Event.find(params[:id])
    current_user.signups.where(:event_id => @event.id).destroy_all
    respond_to do |format|
      format.html { redirect_to @event }
    end
  end
end
