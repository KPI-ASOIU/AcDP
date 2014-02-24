# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	factory :message do
		association :author, factory: :user
		association :conversation
		body { "MyText #{Time.now}" }

		trait :with_subscriptions do
		    after(:build) do |message|
		        FactoryGirl.create_list(:subscription, 3, conversation: message.conversation)
		        message.subscriptions.reject(message.author).each { |m| 
					Subscription.increment_counter(:unread_messages_count, m.id)
				}
		    end
		end
	end
end
