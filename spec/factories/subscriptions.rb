# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subscription do
    association :user
    association :conversation
    unread_messages_count 0
  end
end
