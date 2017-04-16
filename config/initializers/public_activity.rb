# NOTE:
# This is done because of Opinio gem, that needs attr_accessible because of implementation.
# If Opinio is replaced by another gem for Rails 4, we'll be able to remove these lines
# PublicActivity::Activity.class_eval do
#   attr_accessible :connected_to_users
# end
