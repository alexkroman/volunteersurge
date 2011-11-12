class EventSeries < ActiveRecord::Base
  attr_accessor :title, :description, :commit_button, :capacity
  attr_accessor :start_time_date, :start_time_time, :end_time_date, :end_time_time, :end_repeat_time, :endrepeattime
  validates_presence_of :frequency, :period, :starttime, :endtime
  validates_presence_of :title, :description
  has_many :events, :dependent => :destroy
  belongs_to :subdomain
  belongs_to_multitenant :subdomain
  after_create :create_events_until
  before_validation :format_date

   def format_date
     self.starttime = Chronic.parse("#{start_time_date} #{start_time_time}") 
     self.endtime = Chronic.parse("#{end_time_date} #{end_time_time}")
     self.endrepeattime = Chronic.parse("#{end_repeat_time}") + 1.day
   end
  
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
    else
      schedule.add_recurrence_date(starttime)
    end
    schedule.occurrences_between(starttime, endrepeattime).each do |o|
     events.create(:subdomain_id => self.subdomain_id, :capacity => capacity, :title => title, :description => description, :all_day => all_day, :starttime => o, :endtime => o + duration)
    end
  end
  
end
# == Schema Information
#
# Table name: event_series
#
#  id           :integer         not null, primary key
#  frequency    :integer         default(1)
#  period       :string(255)     default("monthly")
#  starttime    :datetime
#  endtime      :datetime
#  all_day      :boolean         default(FALSE)
#  subdomain_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

