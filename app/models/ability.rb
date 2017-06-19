class Ability
  include CanCan::Ability

  def initialize(user)
    # if user isn't signed in
    user ||= User.new

    if user.has_role? :admin
      can :manage, :all
    elsif user.has_role? :tailor
      can :manage, :tailor_orders, tailor: user.store
    elsif user.has_role? :reatiler
      can :manage, :tailor_orders, retailer: user.store
      can :manage, :welcome_kits, retailer: user.store
    else
      # no abilities by default
    end
  end
end
