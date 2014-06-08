class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user

    alias_action :create, :read, :update, :destroy, :update_checklist, :to => :crud
    #
    if user.has_role? :admin
      can :manage, :all
    end

    if !(user.roles & (User::ROLES-['student'])).empty?
      can :crud, Task
    end

    # https://github.com/ryanb/cancan/wiki/Defining-Abilities

    # https://github.com/colinyoung/cancan_strong_parameters
    # http://factore.ca/on-the-floor/258-rails-4-strong-parameters-and-cancan
    # https://github.com/ryanb/cancan/issues/835
  end
end
