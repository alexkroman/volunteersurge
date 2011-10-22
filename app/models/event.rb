# == Schema Information
# Schema version: 20100330111833
#
# Table name: events
#
#  id              :integer(4)      not null, primary key
#  title           :string(255)
#  starttime       :datetime
#  endtime         :datetime
#  all_day         :boolean(1)
#  created_at      :datetime
#  updated_at      :datetime
#  description     :text
#  event_series_id :integer(4)
#

class Event < ActiveRecord::Base
  attr_accessor :period, :frequency, :commit_button, :schedule_yaml
  
  validates_presence_of :title, :description
  
  belongs_to :event_series
  belongs_to :subdomain
  belongs_to_multitenant :subdomain
  has_many :signups
  
  REPEATS = [
              "Does not repeat",
              "Daily"          ,
              "Weekly"         ,
              "Monthly"        ,
              "Yearly"         
  ]
  
  def title_with_capacity
    "#{self.title}, #{self.spots_left} left"
  end
  
  def spots_left
    capacity - signups.size
  end
  
  def validate
    if (starttime >= endtime) and !all_day
      errors.add_to_base("Start Time must be less than End Time")
    end
  end
  
  def update_events(events, event)
    events.each do |e|
      begin 
        st, et = e.starttime, e.endtime
        e.attributes = event
        if event_series.period.downcase == 'monthly' or event_series.period.downcase == 'yearly'
          nst = DateTime.parse("#{e.starttime.hour}:#{e.starttime.min}:#{e.starttime.sec}, #{e.starttime.day}-#{st.month}-#{st.year}")  
          net = DateTime.parse("#{e.endtime.hour}:#{e.endtime.min}:#{e.endtime.sec}, #{e.endtime.day}-#{et.month}-#{et.year}")
        else
          nst = DateTime.parse("#{e.starttime.hour}:#{e.starttime.min}:#{e.starttime.sec}, #{st.day}-#{st.month}-#{st.year}")  
          net = DateTime.parse("#{e.endtime.hour}:#{e.endtime.min}:#{e.endtime.sec}, #{et.day}-#{et.month}-#{et.year}")
        end
      rescue
        nst = net = nil
      end
      if nst and net
        #          e.attributes = event
        e.starttime, e.endtime = nst, net
        e.save
      end
    end
    
    event_series.attributes = event
    event_series.save
  end
  
  
  
end
