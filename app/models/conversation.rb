class Conversation < ActiveRecord::Base
	has_many :messages, -> { order "created_at ASC" }, dependent: :destroy
	has_many :subscriptions, dependent: :destroy
	has_many :participants, through: :subscriptions, source: :user
end
