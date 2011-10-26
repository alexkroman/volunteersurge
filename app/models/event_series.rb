class EventSeries < ActiveRecord::Base
  attr_accessor :title, :description, :commit_button, :capacity
  
  validates_presence_of :frequency, :period, :starttime, :endtime
  validates_presence_of :title, :description
  
  has_many :events, :dependent => :destroy
  belongs_to :subdomain
  belongs_to_multitenant :subdomain
  after_create :create_events_until
  
  def create_events_until
    duration = endtime - starttime
    schedule = IceCube::Schedule.new(starttime)
    if period == 'Daily'
      schedule.rrule IceCube::Rule.daily(frequency)
    elsif period == 'Weekly'
      schedule.rrule IceCube::Rule.weekly(frequency)      
    elsif period == 'Monthly'
      schedule.rrule IceCube::Rule.monthly(frequency)
    elsif period == 'Yearly'
      schedule.rrule IceCube::Rule.yearly(frequency)
    end
    schedule.occurrences_between(starttime, Time.local(2015,1,1)).each do |o|
     events.create(:subdomain_id => self.subdomain_id, :capacity => capacity, :title => title, :description => description, :all_day => all_day, :starttime => o, :endtime => o + duration)
    end
  end
  
end