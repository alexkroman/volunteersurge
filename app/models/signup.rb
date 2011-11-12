class Signup < ActiveRecord::Base
  belongs_to :event, :counter_cache => true
  belongs_to :event_series
  belongs_to :user
  belongs_to :subdomain
  belongs_to_multitenant :subdomain
  validates_presence_of :subdomain, :user, :event
  default_value_for :number_attending, 1
end

# == Schema Information
#
# Table name: signups
#
#  id              :integer         not null, primary key
#  user_id         :integer
#  event_id        :integer
#  event_series_id :integer
#  subdomain_id    :integer
#  created_at      :datetime
#  updated_at      :datetime
#

