class Message < ActiveRecord::Base
	after_create :inc_unread_messages

	belongs_to :author, class_name: "User"
	belongs_to :conversation
	has_many :subscriptions, through: :conversation

	validates :conversation_id, :author_id, :body, presence: true

	private
	def inc_unread_messages
		Subscription.increment_counter(:unread_messages_count, find_all_subscription_ids_except(self.author_id))
	end

	def find_all_subscription_ids_except(id)
		self.subscriptions.where.not(user_id: id).pluck(:id)
	end
end
