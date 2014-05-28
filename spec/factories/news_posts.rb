# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :news_post do
    title "MyString"
    text "MyText"
    tags "MyString"
    creator_id 1
    for_roles 1
    created_at "2014-05-25 23:55:47"
    updated_at "2014-05-25 23:55:47"
  end
end
