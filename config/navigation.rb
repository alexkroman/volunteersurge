SimpleNavigation::Configuration.run do |navigation|  
  navigation.selected_class = 'active'
  navigation.autogenerate_item_ids = false


  navigation.items do |primary|
    if current_subdomain
      primary.item :dashboard, 'Dashboard', dashboard_index_path, :if => Proc.new { can? :create, Event }
      primary.item :calendar, 'Schedule', events_path
      if user_signed_in?
        primary.item :calendar, 'My Shifts', shifts_path, :unless => Proc.new { can? :create, Event } 
      end
      primary.item :volunteers, 'Volunteers', volunteers_path, :if => Proc.new { can? :create, Event }
      primary.item :shifts, 'Settings', sites_path, :if => Proc.new { can? :create, Event }    
      if current_subdomain.faq
        primary.item :faq, 'FAQ', faq_sites_path, :unless => Proc.new { can? :create, Event }    
      end
    end
  end
  
end
