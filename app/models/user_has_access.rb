class UserHasAccess < ActiveRecord::Base
	belongs_to :user
	belongs_to :document

  validates_uniqueness_of :document_id, scope: [:user_id]

	after_destroy do |access|
		if access.document.users.nil?
      access.document.destroy
		end
	end
end
