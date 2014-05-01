class UserHasAccess < ActiveRecord::Base
	belongs_to :user, dependent: :destroy
	belongs_to :document, dependent: :destroy
	after_destroy do |document|
		if document.users.nil?
			document.destroy
		end
	end
end
