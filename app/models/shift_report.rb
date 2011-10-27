class ShiftReport

  include Datagrid

  scope do
    Event
  end
  
  filter(:short, :boolean) do |value|
    self.limit(6)
  end

  column(:title)
  column(:starttime)
  column(:endtime)
  column(:capacity)


end