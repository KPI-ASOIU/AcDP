class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user
    #
    if user.has_role? :admin
      can :manage, :all
    end
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities

    # https://github.com/colinyoung/cancan_strong_parameters
    # http://factore.ca/on-the-floor/258-rails-4-strong-parameters-and-cancan
    # https://github.com/ryanb/cancan/issues/835
  end
end
