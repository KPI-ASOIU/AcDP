class Message < ActiveRecord::Base
	belongs_to :user

	validates_presence_of :conversation_id
	validates_presence_of :author_id
	validates_presence_of :body
end
