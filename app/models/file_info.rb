class FileInfo < ActiveRecord::Base
  has_attached_file :file
  do_not_validate_attachment_file_type :file
	belongs_to :document, class_name: 'Document', foreign_key: :document_id
  paginates_per 2
end
