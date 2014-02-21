# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
  	association :author, factory: :user
    conversation_id { Time.now.to_i }
    body "MyText" + Time.now.to_s
  end
end
