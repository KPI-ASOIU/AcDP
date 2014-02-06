# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
  end

  factory :user_admin, parent: :user do
    # TODO: set role = admin
  end
end
