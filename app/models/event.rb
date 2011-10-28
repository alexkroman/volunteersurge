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
  attr_accessor :period, :frequency, :commit_button
  validates_presence_of :title, :description
  belongs_to :event_series
  belongs_to :subdomain
  belongs_to_multitenant :subdomain
  has_many :signups
  
  default_value_for :all_day, false
  default_value_for :capacity, 5
  
  
  REPEATS = [
              "Does not repeat",
              "Daily"          ,
              "Weekly"         ,
              "Monthly"        ,
              "Yearly"         
  ]
  
  def self.upcoming
    where(["starttime > ?", Time.now]).order('starttime asc')
  end
    
  def title_with_capacity
    "#{self.title}, #{self.spots_left} left"
  end
  
  def spots_left
    capacity - signups.size if capacity
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
