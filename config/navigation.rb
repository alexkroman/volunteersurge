SimpleNavigation::Configuration.run do |navigation|  
  navigation.selected_class = 'active'
  navigation.autogenerate_item_ids = false
  
  
  navigation.items do |primary|
    primary.item :dashboard, 'Dashboard', dashboard_index_path
    primary.item :shifts, 'Shifts', shifts_path
    primary.item :calendar, 'Calendar', events_path
    primary.item :volunteers, 'Volunteers', users_path
    primary.dom_id = 'MainTabs'
    # primary.dom_class = 'menu-class'
  end
end