# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    conversation_id 1
    author_id 1
    body "MyText"
  end
end
