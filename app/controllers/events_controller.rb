class EventsController < ApplicationController
  authorize_resource
  autocomplete :user, :name, :full => true

  def delete_confirmation
    @event = Event.find(params[:id])
    respond_to do |format|
      format.html { render :layout => !request.xhr? }
    end
    authorize! :edit, @event
  end

  def new
    @event_series = Event.new
    respond_to do |format|
      format.js
    end
    authorize! :new, @event
  end

  def create
    @event_series = EventSeries.new(params[:event])

    respond_to do |format|
      if @event_series.save
        format.js { render :nothing => true }
      else
        format.json { render :json => @event_series.errors, :status => :unprocessable_entity }
      end
    end
  end

  def index
    @event = Event.new(:starttime => 1.hour.from_now, :endtime => 2.hours.from_now, :period => "Does not repeat")
  end

  def show
    @event = Event.find(params[:id])
    @signup = @event.signups.find_by_user_id(current_user.id) || Signup.new(:event => @event)
    respond_to do |format|
      format.html do
        if current_user.admin?
          render :admin_show
        else
          render :show
        end
      end
    end
  end

  def popup
    @event = Event.find(params[:id])
    respond_to do |format|
      format.html { render :layout => !request.xhr? }
    end
  end

  def retrieve
    @events = Event.find(:all, :include => :event_series, :conditions => ["starttime >= '#{Time.at(params['start'].to_i).to_formatted_s(:db)}' and endtime <= '#{Time.at(params['end'].to_i).to_formatted_s(:db)}'"] )
    events = []
    @events.each do |event|
      if event.users.include?(current_user)
        class_name = 'attending'
        title = event.title + ", attending"
      else
        class_name = 'not-attending'
        title = event.title_with_capacity
      end
      events << {:className => class_name, :id => event.id, :title => title, :description => event.description, :start => "#{event.starttime.iso8601}", :end => "#{event.endtime.iso8601}", :allDay => event.all_day, :recurring => (event.repeat?)? false : true}
    end
    respond_to do |format|
      format.json {render :json => events.to_json}
    end
  end


  def edit
    @event = Event.find(params[:id])
    respond_to do |format|
      format.js
    end
    authorize! :edit, @event
  end

  def update
    @event = Event.find(params[:id])
    if params[:event][:commit_button] == "Update All"
      @events = @event.event_series.events
      success = @event.update_events(@events, params[:event])
      errors = @events.errors
    elsif params[:event][:commit_button] == "Update Following Events"
      @events = @event.event_series.events.find(:all, :conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
      success = @event.update_events(@events, params[:event])
      errors = @events.errors
    else
      @event.attributes = params[:event]
      success = @event.save
      errors = @event.errors
    end
    respond_to do |format|
      if success 
        format.js { render :nothing => true }
      else
        format.json { render :json => errors, :status => :unprocessable_entity }
      end
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
