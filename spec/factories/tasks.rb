# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task do
    name "MyString"
    description "MyText"
    end_date "2014-04-24 22:53:46"
    status "MyString"
    check_list "MyText"
  end
end
