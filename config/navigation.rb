SimpleNavigation::Configuration.run do |navigation|  
  navigation.selected_class = 'active'
  navigation.autogenerate_item_ids = false
  
  
  navigation.items do |primary|
    primary.item :dashboard, 'Dashboard', dashboard_index_path, :if => Proc.new { can? :create, Event }
    primary.item :volunteers, 'Volunteers', volunteer_reports_path, :if => Proc.new { can? :create, Event }
    primary.item :shifts, 'Shifts', shifts_path, :if => Proc.new { can? :create, Event }
    primary.item :calendar, 'Calendar', events_path
    primary.item :shifts, 'Reports', shifts_path, :if => Proc.new { can? :create, Event }
    primary.item :shifts, 'Settings', shifts_path, :if => Proc.new { can? :create, Event }
    primary.item :shifts, 'My Shifts', signups_path, :unless => Proc.new { can? :create, Event }
    
  end
  
end