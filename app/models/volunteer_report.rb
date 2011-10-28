class VolunteerReport

  include Datagrid

  scope do
    User
  end
  
  filter(:short, :boolean) do |value|
    self.limit(6)
  end

  column(:name)
  column(:email)
  column(:created_at)


end