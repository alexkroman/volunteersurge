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
  scoped_search :on => [:name, :email]
    
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
# == Schema Information
#
# Table name: users
#
#  id                   :integer         not null, primary key
#  email                :string(255)     default(""), not null
#  encrypted_password   :string(128)     default(""), not null
#  reset_password_token :string(255)
#  remember_token       :string(255)
#  remember_created_at  :datetime
#  sign_in_count        :integer         default(0)
#  current_sign_in_at   :datetime
#  last_sign_in_at      :datetime
#  current_sign_in_ip   :string(255)
#  last_sign_in_ip      :string(255)
#  name                 :string(255)
#  loginable_token      :string(40)
#  admin                :boolean
#  created_at           :datetime
#  updated_at           :datetime
#  subdomain_id         :integer
#

