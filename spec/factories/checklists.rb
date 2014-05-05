# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :checklist do
    done false
    name "MyString"
    task_id 1
  end
end
