class Subdomain < ActiveRecord::Base
  has_many :users
  has_one :user
  has_many :events
  has_many :event_series
  has_many :signups
  validates_uniqueness_of :name, :case_sensitive => false
  validates_presence_of :name, :organization
end

# == Schema Information
#
# Table name: subdomains
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  organization :string(255)
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

