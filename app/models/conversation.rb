class Conversation < ActiveRecord::Base
	has_many :messages, -> { order "created_at ASC" }, dependent: :destroy
	has_many :subscriptions, dependent: :destroy
	has_many :participants, through: :subscriptions, source: :user

  has_and_belongs_to_many :documents, join_table: :conversations_documents
end
