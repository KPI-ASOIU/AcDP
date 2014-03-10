module SubscriptionsHelper
	def unread_messages_for(user)
		Array(user.subscriptions).map { |sub| sub.unread_messages_count }.sum
	end
end
