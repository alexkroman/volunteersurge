class Signup < ActiveRecord::Base
  belongs_to :event
  belongs_to :event_series
  belongs_to :user
end
