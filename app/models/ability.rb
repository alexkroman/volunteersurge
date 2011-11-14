class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    elsif user.id != nil
      can :signup, :all
      can :dashboard, :all
      can :create, Signup
      can :destroy, Signup
      can :complete, Event
    end
    can :faq, :all
    can :read, :all
    can :retrieve, :all
    can :popup, :all
  end
  
end
