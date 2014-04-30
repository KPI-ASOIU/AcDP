class DocumentType < ActiveRecord::Base
	has_many :documents, through: :document_has_types
	has_many :document_has_types
end
