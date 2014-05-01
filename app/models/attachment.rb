class Attachment < ActiveRecord::Base
	has_attached_file :file,
    :path => ":rails_root/public/system/users/attachments/:id/:filename",
    :url => "/system/users/attachments/:id/:filename"

  validates_attachment_size :file, :less_than => 50.megabytes
  #validates_attachment :file,
   # :size => { :in => 0..50.megabytes }
  has_many :users, through: :user_has_attachments
  has_many :user_has_attachments
end
