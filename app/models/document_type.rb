class DocumentType < ActiveRecord::Base
	has_many :documents, through: :document_has_types
	has_many :document_has_types, dependent: :destroy
	validates_presence_of :title
	validates_length_of :title, :maximum => 45
	validates_uniqueness_of :title
end
