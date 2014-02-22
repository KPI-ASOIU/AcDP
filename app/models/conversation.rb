class Conversation < ActiveRecord::Base
	has_many :messages, -> { order "created_at DESC" }
	has_many :subscriptions
end
