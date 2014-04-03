class UserHasAttachment < ActiveRecord::Base
	belongs_to :user, dependent: :destroy
	belongs_to :attachment, dependent: :destroy

	after_destroy do |attachment|
		if attachment.users.nil?
			attachment.destroy
		end
	end
end