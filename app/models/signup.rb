class Signup < ActiveRecord::Base
  belongs_to :event
  belongs_to :event_series
  belongs_to :user
  belongs_to :subdomain
  belongs_to_multitenant :subdomain
end
