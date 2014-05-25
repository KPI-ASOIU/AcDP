# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    name "MyString"
    description "MyText"
    date "2014-05-17 13:58:44"
    place "MyString"
    plan "MyText"
  end
end
