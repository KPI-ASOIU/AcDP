class DocumentHasType < ActiveRecord::Base
	belongs_to :document
	belongs_to :document_type
end
