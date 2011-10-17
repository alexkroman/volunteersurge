class User < ActiveRecord::Base
  belongs_to :subdomain
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates_presence_of :name
  validates_presence_of :subdomain_name, :on => :create # used to create a subdomain
  validates_uniqueness_of  :email, :case_sensitive => false
  attr_accessor :subdomain_name  # used to create a subdomain
  attr_accessible :name, :subdomain_name, :email, :password, :password_confirmation, :loginable_token
  before_create :create_subdomain
  after_create :update_subdomain_owner

  def self.valid?(params)
    token_user = self.where(:loginable_token => params[:id]).first
    if token_user
      token_user.loginable_token = nil
      token_user.save
    end
    return token_user
  end
  
  private

  def create_subdomain
    # get or create a subdomain on creating a new user
    self.subdomain = Subdomain.find_by_name(self.subdomain_name) 
    self.subdomain ||= Subdomain.create!(:name => self.subdomain_name)
  end

  def update_subdomain_owner
    # set owner of subdomain to user that created it
    subdomain = self.subdomain
    if subdomain && subdomain.user_id.nil?
      subdomain.user_id = self.id
      subdomain.save
    end
  end
  
end


  # def self.find_for_authentication(conditions={})
  #   #conditions[:active] = true
  #   logger.info conditions.inspect
  #   super
  # end
