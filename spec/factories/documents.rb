# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :document do
  	parent_directory nil
  	type 1
  	title 'document title'
  	description 'document description'
  	tags 'document tags'
  	association :document_folder, class_name: 'Document', foreign_key: :parent_directory
  end
  trait :with_document_folders do
    after(:create) do |document|
    	FactoryGirl.create_list(:child_document, 2, parent_directory: document.id)
    end
  end
end
