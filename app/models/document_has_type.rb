class DocumentHasType < ActiveRecord::Base
	belongs_to :document
	belongs_to :document_type

  validates_uniqueness_of :document_id, scope: [:document_type_id]
end
