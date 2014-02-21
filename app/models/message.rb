class Message < ActiveRecord::Base
	belongs_to :author, class_name: "User"

	validates :conversation_id, :author_id, :body, presence: true
end
