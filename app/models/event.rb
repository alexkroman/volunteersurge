class Event < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, :use => :slugged
  attr_accessor :period, :frequency, :commit_button, :start_time_date, :start_time_time, :end_time_date, :end_time_time
  validates_presence_of :title, :description
  belongs_to :event_series
  belongs_to :subdomain
  belongs_to_multitenant :subdomain
  has_many :signups
  has_many :users, :through => :signups
  default_value_for :all_day, false
  default_value_for :capacity, 5

  REPEATS = [
              "Does not repeat",
              "Daily"          ,
              "Weekly"         ,
              "Monthly"        ,
              "Yearly"         
  ]

  
  def start_time_date
    (starttime ? starttime : Date.today).strftime('%Y-%m-%d')
  end
  
  def start_time_time
    (starttime ? starttime : Time.now).strftime('%I:%M%p')
  end
  
  def end_time_date
    (endtime ? endtime : Date.today).strftime('%Y-%m-%d') 
    
  end
  
  def end_time_time
    (endtime ? endtime : Time.now + 1.hour).strftime('%I:%M%p') 
  end
  
  def repeat?
    return false if event_series.period == 'Does not repeat'
    return true
  end
 
  def update_events(events, event)
    events.each do |e|
        st, et = e.starttime, e.endtime
        e.attributes = event
        e.starttime, e.endtime = st, ed
        e.save
    end
    
    event_series.attributes = event
    event_series.save
  end
    
  def self.upcoming
    where(["starttime > ?", Time.now]).order('starttime asc')
  end
    
  def title_with_capacity
    "#{self.title}, #{self.spots_left} left"
  end
  
  def spots_left
    capacity - signups_count if capacity
  end
  
  def spots_filled
    signups.size
  end
  
  def validate
    if (starttime >= endtime) and !all_day
      errors.add_to_base("Start Time must be less than End Time")
    end
  end  
  
end

# == Schema Information
#
# Table name: events
#
#  id              :integer         not null, primary key
#  title           :string(255)
#  starttime       :datetime
#  endtime         :datetime
#  capacity        :integer
#  all_day         :boolean         default(FALSE)
#  subdomain_id    :integer
#  created_at      :datetime
#  updated_at      :datetime
#  description     :text
#  event_series_id :integer
#  signups_count   :integer         default(0)
#

