# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_has_access do
  	association :user
  	association :document
  end
end
