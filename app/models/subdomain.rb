class Subdomain < ActiveRecord::Base
  has_many :users
  validates_uniqueness_of :name, :case_sensitive => false
  validates_presence_of :name
end
