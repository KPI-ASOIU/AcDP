# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
  	association :author, factory: :user
  	association :conversation
  	body { "MyText #{Time.now}" }
  end
end
