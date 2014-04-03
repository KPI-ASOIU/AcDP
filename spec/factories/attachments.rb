# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :attachment do
  	file_file_name 'name_of_file'
  	file_content_type 'type_of_file'
  	file_file_size 30
  	file_updated_at Time.now
    
    factory :attachment_with_users do
    	after(:build) do |attachment|
    		FactoryGirl.create_list(:user, 3, user_has_attachment: attachment.user_has_attachment)
    	end
    end
  end
end