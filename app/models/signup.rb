class Signup < ActiveRecord::Base
  belongs_to :event, :counter_cache => true
  belongs_to :event_series
  belongs_to :user
  belongs_to :subdomain
  belongs_to_multitenant :subdomain
  
  validates_presence_of :subdomain, :user, :event
end
