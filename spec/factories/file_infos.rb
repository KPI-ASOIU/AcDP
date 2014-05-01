# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :file_info do
  	association :document
  end
end
