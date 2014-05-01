class Document < ActiveRecord::Base
	has_many :users, through: :user_has_accesses
	has_many :user_has_accesses
	has_many :document_types, through: :document_has_types
	has_many :document_has_types
	has_many :child_documents, class_name: 'Document', foreign_key: :parent_directory
  belongs_to :document_folder, class_name: 'Document', foreign_key: :parent_directory
end
