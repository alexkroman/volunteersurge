class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    elsif user.id != nil
      can :signup, :all
      can :signup_all, :all
      can :cancel_signup, :all
      can :cancel_all_signups, :all
    end  
    can :read, :all
    can :retrieve, :all
  end
  
end
