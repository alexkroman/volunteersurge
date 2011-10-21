class Subdomain < ActiveRecord::Base
  has_many :users
  has_many :events
  has_many :event_series
  has_many :signups
  validates_uniqueness_of :name, :case_sensitive => false
  validates_presence_of :name, :organization
end
