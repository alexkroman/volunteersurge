class User < ActiveRecord::Base
  belongs_to :subdomain
  belongs_to_multitenant :subdomain
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates_presence_of :name
  validates_presence_of :subdomain_name, :on => :create # used to create a subdomain
  validates_presence_of :organization_name, :on => :create # used to create a subdomain
  attr_accessor :subdomain_name, :organization_name  # used to create a subdomain
  attr_accessible :name, :subdomain_name, :organization_name, :email, :password, :password_confirmation, :remember_me, :loginable_token
  before_create :create_subdomain
  after_create :update_subdomain_owner
  has_many :signups
  has_many :events, :through => :signups

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
    self.subdomain = Subdomain.find_by_name(self.subdomain_name) 
    self.subdomain ||= Subdomain.create!(:name => self.subdomain_name, :organization => self.organization_name)
  end

  def update_subdomain_owner
    # set owner of subdomain to user that created it
    subdomain = self.subdomain
    if subdomain && subdomain.user_id.nil?
      subdomain.user_id = self.id
      self.admin = true
      self.save
      subdomain.save
    end
  end
  
end