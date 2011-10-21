# == Schema Information
# Schema version: 20100330111833
#
# Table name: event_series
#
#  id         :integer(4)      not null, primary key
#  frequency  :integer(4)      default(1)
#  period     :string(255)     default("months")
#  starttime  :datetime
#  endtime    :datetime
#  all_day    :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

class EventSeries < ActiveRecord::Base
  attr_accessor :title, :description, :commit_button
  
  validates_presence_of :frequency, :period, :starttime, :endtime
  validates_presence_of :title, :description
  has_many :events, :dependent => :destroy
  after_create :create_events
  
  
  def create_events
    logger.info "============================================HI"
    
    rule = IceCube::Rule.daily
      
    schedule = IceCube::Schedule.new
    schedule.add_recurrence_rule rule
    
    logger.info schedule.occurrences(Time.local(2015, 1, 1)).size
  
  end
  
  def r_period(period)
    case period
      when 'Daily'
      p = 'days'
      when "Weekly"
      p = 'weeks'
      when "Monthly"
      p = 'months'
      when "Yearly"
      p = 'years'
    end
    return p
  end
  
end
