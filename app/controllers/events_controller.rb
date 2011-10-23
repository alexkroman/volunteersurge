class EventsController < ApplicationController
  load_and_authorize_resource
    
  def new
    @event = Event.new(:starttime => 1.hour.from_now, :endtime => 2.hours.from_now, :period => "Does not repeat")
    respond_to do |format|
      format.js
    end
    authorize! :new, @event
  end
  
  def create
    if params[:event][:period] == "Does not repeat"
      @event = Event.new(params[:event])
    else
      @event_series = EventSeries.new(params[:event])
    end
    respond_to do |format|
      format.js
    end
  end
  
  def index
    @signups = current_user.signups.limit(10) if user_signed_in?
  end
  
  def show
    @event = Event.find(params[:id])
    respond_to do |format|
      format.js
      format.html
    end
  end
  
  def retrieve
    @events = Event.find(:all, :conditions => ["starttime >= '#{Time.at(params['start'].to_i).to_formatted_s(:db)}' and endtime <= '#{Time.at(params['end'].to_i).to_formatted_s(:db)}'"] )
    events = [] 
    @events.each do |event|
      events << {:id => event.id, :title => event.title_with_capacity, :description => event.description || "Some cool description here...", :start => "#{event.starttime.iso8601}", :end => "#{event.endtime.iso8601}", :allDay => event.all_day, :recurring => (event.event_series_id)? true: false}
    end
    respond_to do |format|
      format.json {render :json => events.to_json}
    end
  end
  
  def signup
    @event = Event.find(params[:id])
    Signup.create!(:event => @event, :event_series => @event.event_series, :user => current_user)
    redirect_to events_path
  end
  
  def signup_all
    @event = Event.find(params[:id])
    @event.event_series.events.each do |event|
      Signup.create!(:user => current_user, :event => event, :event_series => event.event_series )
    end
    redirect_to events_path
  end
  
  def cancel_signup
    current_user.signups.find(params[:id]).destroy
    redirect_to events_path
  end
  
  def cancel_all_signups
    series_id = current_user.signups.find(params[:id]).event_series.id
    current_user.signups.where(:event_series_id => series_id).destroy_all
    redirect_to events_path
  end
  
  def move
    @event = Event.find_by_id params[:id]
    if @event
      @event.starttime = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.starttime))
      @event.endtime = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.endtime))
      @event.all_day = params[:all_day]
      @event.save
    end
    respond_to do |format|
      format.js
    end
    authorize! :create, @event
  end
    
  def resize
    @event = Event.find_by_id params[:id]
    if @event
      @event.endtime = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.endtime))
      @event.save
    end
    respond_to do |format|
      format.js
    end
    authorize! :create, @event
    
  end
  
  def edit
    @event = Event.find(params[:id])
    respond_to do |format|
      format.js
    end
    authorize! :edit, @event
  end
  
  def update
    @event = Event.find_by_id(params[:event][:id])
    if params[:event][:commit_button] == "Update All Occurrence"
      @events = @event.event_series.events #.find(:all, :conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
      @event.update_events(@events, params[:event])
    elsif params[:event][:commit_button] == "Update All Following Occurrence"
      @events = @event.event_series.events.find(:all, :conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
      @event.update_events(@events, params[:event])
    else
      @event.attributes = params[:event]
      @event.save
    end

    render :update do |page|
      page<<"$('#calendar').fullCalendar( 'refetchEvents' )"
      page<<"$('#desc_dialog').dialog('destroy')" 
    end
    authorize! :update, @event
  
  end  
  
  def destroy
    @event = Event.find_by_id(params[:id])
    if params[:delete_all] == 'true'
      @event.event_series.destroy
    elsif params[:delete_all] == 'future'
      @events = @event.event_series.events.find(:all, :conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
      @event.event_series.events.delete(@events)
    else
      @event.destroy
    end
    
    render :update do |page|
      page<<"$('#calendar').fullCalendar( 'refetchEvents' )"
      page<<"$('#desc_dialog').dialog('destroy')" 
    end
    
    authorize! :destroy, @event
  
  end
  
end
