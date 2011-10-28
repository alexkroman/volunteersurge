class SignupReport

  include Datagrid

  scope do
    Signup
  end
  
  filter(:short, :boolean) do |value|
    self.limit(6)
  end

  column(:created_at)


end