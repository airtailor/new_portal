class Ability
  include CanCan::Ability

  def initialize(user)
    # if user isn't signed in
    user ||= User.new

    if user.has_role? :admin
      can :manage, :all
    else 
      # no abilities by default
    end
  end
end
