require 'test_helper'

class SubdomainTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
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

