# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	factory :message do
		association :author, factory: :user
		association :conversation
		body { "MyText #{Time.now}" }

		after(:create) do |message|
			Subscription.increment_counter(:unread_messages_count, message.subscriptions.pluck(:id).reject{ |id| id == message.author_id })
		end

		trait :with_subscriptions do
	    after(:build) do |message|
	      FactoryGirl.create_list(:subscription, 3, conversation: message.conversation)
	    end
		end		
	end
end
