class EventsController < ApplicationController
  authorize_resource
  
  def new
    @event_series = Event.new
    respond_to do |format|
      format.js
    end
    authorize! :new, @event
  end
  
  def create
    @event_series = EventSeries.new(params[:event]).save!
        
    respond_to do |format|
      format.js
    end

  end
  
  def index
    @event = Event.new(:starttime => 1.hour.from_now, :endtime => 2.hours.from_now, :period => "Does not repeat")
  end
  
  def show
    @event = Event.find(params[:id])
    respond_to do |format|
      format.html { render :layout => !request.xhr? }
    end
  end
  
  def retrieve
    
    @events = Event.find(:all, :include => :event_series, :conditions => ["starttime >= '#{Time.at(params['start'].to_i).to_formatted_s(:db)}' and endtime <= '#{Time.at(params['end'].to_i).to_formatted_s(:db)}'"] )
    
    events = [] 
    @events.each do |event|
      events << {:className => (event.users.include?(current_user)) ? 'attending' : 'not-attending', :id => event.id, :title => event.title_with_capacity, :description => event.description || "Some cool description here...", :start => "#{event.starttime.iso8601}", :end => "#{event.endtime.iso8601}", :allDay => event.all_day, :recurring => (event.repeat?)? false : true}
    end
    respond_to do |format|
      format.json {render :json => events.to_json}
    end
  end
  
  def signup
    @event = Event.find(params[:id])
    Signup.create!(:event => @event, :event_series => @event.event_series, :user => current_user)
    flash[:message] = 'You have been signed up!'
    respond_to do |format|
      format.js
    end
  end
  
  def signup_all
    @event = Event.find(params[:id])
    @event.event_series.events.where(["events.starttime >= ?", @event.starttime]).each do |event|
      Signup.create!(:user => current_user, :event => event, :event_series => event.event_series )
    end
    respond_to do |format|
      format.js
    end
  end
  
  def cancel_signup
    current_user.signups.where(:event_id => params[:id]).destroy_all
    respond_to do |format|
      format.js
    end  
  end
  
  def cancel_all_signups
    series_id = current_user.signups.find(params[:id]).event_series.id
    current_user.signups.where(:event_series_id => series_id).destroy_all
    respond_to do |format|
      format.js
    end 
  end
 
  def edit
    @event = Event.find(params[:id])
    respond_to do |format|
      format.js
    end
    authorize! :edit, @event
  end
  
  def delete_confirmation
    @event = Event.find(params[:id])
    respond_to do |format|
      format.html { render :layout => !request.xhr? }
    end
    authorize! :edit, @event
  end
  
  def update
    @event = Event.find(params[:id])
    if params[:event][:commit_button] == "Update All"
      @events = @event.event_series.events
      @event.update_events(@events, params[:event])
    elsif params[:event][:commit_button] == "Update Following Events"
      @events = @event.event_series.events.find(:all, :conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
      @event.update_events(@events, params[:event])
    else
      @event.attributes = params[:event]
      @event.save
    end

    respond_to do |format|
      format.js
    end
    
    authorize! :update, @event
  
  end  
  
  def destroy
    @event = Event.find(params[:id])
    if params[:delete_all] == 'following'
      @events = @event.event_series.events.find(:all, :conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
      @event.event_series.events.delete(@events)
    elsif params[:delete_all] == 'all'
      @event.event_series.destroy
    else
      @event.destroy
    end
    
    respond_to do |format|
      format.js
    end
    
    authorize! :destroy, @event
  
  end
  
end
