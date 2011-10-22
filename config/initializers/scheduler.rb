scheduler = Rufus::Scheduler.start_new  
  
scheduler.every("1d") do  
   #p "I am sending out some email" 
end