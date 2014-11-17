class CreateConversationsDocuments < ActiveRecord::Migration
  def change
    create_table :conversations_documents do |t|
      t.belongs_to :conversation
      t.belongs_to :document
    end
  end
end
