class VolunteerReport

  include Datagrid

  scope do
    User
  end
  
  filter(:short, :boolean) do |value|
    self.limit(6)
  end

  filter(:name, :string) do |value|
    self.where(["name like ? or email like ?", "%#{value}%", "%#{value}%"])
  end
  
  column(:name)
  column(:email)
  column(:created_at, :header => 'Joined on') do |user|
    user.created_at.strftime('%m/%d/%y')
  end


end