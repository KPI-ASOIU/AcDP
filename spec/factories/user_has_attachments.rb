# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_has_attachment do
  	association :user
  	association :attachment
  end
end
