# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
puts 'SETTING UP EXAMPLE USERS'
user1 = User.create! :name => 'Foo First User', :subdomain_name => "foo", :email => 'user1@test.com', :password => 'please', :password_confirmation => 'please'
puts 'New user created: ' << user1.name
user2 = User.create! :name => 'Bar First User', :subdomain_name => "bar", :email => 'user2@test.com', :password => 'please', :password_confirmation => 'please'
puts 'New user created: ' << user2.name
user3 = User.create! :name => 'Foo Second User', :subdomain_name => "foo", :email => 'user3@test.com', :password => 'please', :password_confirmation => 'please'
puts 'New user created: ' << user3.name
user4 = User.create! :name => 'Bar Second User', :subdomain_name => "bar", :email => 'user4@test.com', :password => 'please', :password_confirmation => 'please'
puts 'New user created: ' << user4.name

# subdomains creation removed because they are created automaticaly by user signup left only the display
