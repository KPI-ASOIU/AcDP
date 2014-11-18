class CreateTasksDocuments < ActiveRecord::Migration
  def change
    create_table :tasks_documents do |t|
      t.belongs_to :task
      t.belongs_to :document
    end
  end
end
