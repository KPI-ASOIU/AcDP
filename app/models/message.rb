class Message < ActiveRecord::Base
	after_create :inc_unread_messages

	belongs_to :author, class_name: "User"
	belongs_to :conversation
	has_many :subscriptions, through: :conversation

	validates :conversation_id, :author_id, :body, presence: true

	def inc_unread_messages
		Subscription.increment_counter(:unread_messages_count, Subscription.where('user_id <> ?', self.author_id).pluck(:id))
	end
end
