class FileInfo < ActiveRecord::Base
  versioned

  has_attached_file :file,
                    :keep_old_files => true,
                    :url => "/system/file_infos/files/:id/versions/:version/:style/:basename.:extension",
                    :path => ":rails_root/public/system/file_infos/files/:id/versions/:version/:style/:basename.:extension"
  do_not_validate_attachment_file_type :file
	belongs_to :document, class_name: 'Document', foreign_key: :document_id
  paginates_per 2

  Paperclip.interpolates :version do |attachment, style|
    attachment.instance.version.to_s
  end
end
