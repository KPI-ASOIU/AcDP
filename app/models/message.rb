class Message < ActiveRecord::Base
	after_create do |message|
		message.subscriptions.reject(message.author).each { |m| 
			Subscription.increment_counter(:unread_messages_count, m.id)
		}
	end

	belongs_to :author, class_name: "User"
	belongs_to :conversation
	has_many :subscriptions, through: :conversation

	validates :conversation_id, :author_id, :body, presence: true
end
