class Conversation < ActiveRecord::Base
	has_many :messages, -> { order "created_at ASC" }
	has_many :subscriptions
	has_many :participants, through: :subscriptions, source: :user
end
