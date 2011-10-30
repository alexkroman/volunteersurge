class Site < Subdomain
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

