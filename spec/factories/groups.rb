# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group do
    name "MyString"
    start_year 1
    graduation_year 1
    full_time false
    degree 1
    speciality "MyString"
    speciality_code "MyString"
  end
end
