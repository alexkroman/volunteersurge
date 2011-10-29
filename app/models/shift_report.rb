class ShiftReport

  include Datagrid

  scope do
    Event
  end
  
  filter(:short, :boolean) do |value|
    self.limit(6)
  end

  filter(:name, :string) do |value|
    self.where(["title like ?", "%#{value}%"])
  end

  column(:title, :header => 'Name')
  column(:starttime, :header => 'Shift Time', :order => 'starttime') do
    "#{starttime.strftime('%m/%d/%Y %r')} to #{endtime.strftime('%m/%d/%Y %r')}"
  end

  column(:capacity)
  column(:signups_count, :header => 'Signups')
  
end