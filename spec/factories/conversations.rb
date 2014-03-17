# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :conversation do
    sequence(:subject) do |n|
    	"Topic#{n}"
    end

    trait :with_messages do
    	after(:create) do |conversation|
    		FactoryGirl.create_list(:message, 3, conversation: conversation)
    	end
    end

    trait :subscript_users do
      after(:build) do |conversation|
        FactoryGirl.create_list(:subscription, 3, conversation: conversation).each{|sub|
          sub.user = FactoryGirl.create(:user)
        }
      end
    end
  end
end
