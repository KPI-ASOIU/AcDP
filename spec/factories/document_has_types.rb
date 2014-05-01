# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :document_has_type do
    association :document
    association :document_type
  end
end
