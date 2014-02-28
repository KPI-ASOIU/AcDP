# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:login) do |n|
     "user#{n}"
    end

    sequence(:full_name) do |n|
      "username#{n}"
    end
    password { |u| "#{u.login}-password" }
    password_confirmation { |u| u.password }
    email { |u| "#{u.login}@asoui.fiot.kpi.ua"}

    factory :user_with_subscriptions do
      after(:build) do |user|
          FactoryGirl.create_list(:subscription, 3, user: user)
      end
    end
  end

  factory :user_admin, parent: :user do
    sequence(:login) do |n|
     "admin#{n}"
    end
    role 8
  end

  factory :user_student, parent: :user do
    sequence(:login) do |n|
      student_number = (n % 30).to_s.rjust(2, "0")
      group_number = ((n/30) % 100).to_s.rjust(2, "0")
      group_letter = ("s".ord + n/3000).chr
     "i#{group_letter}#{group_number}#{student_number}"
    end
  end

  factory :invalid_user, parent: :user do
    password "123"
    email "ololo"
  end
end
