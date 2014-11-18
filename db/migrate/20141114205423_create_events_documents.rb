class CreateEventsDocuments < ActiveRecord::Migration
  def change
    create_table :events_documents do |t|
      t.belongs_to :event
      t.belongs_to :document
    end
  end
end
