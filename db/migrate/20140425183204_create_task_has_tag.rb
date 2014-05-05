class CreateTaskHasTag < ActiveRecord::Migration
  def change
    create_table :task_has_tags do |t|
      t.integer :task_id
      t.integer :tag_id
    end
  end
end
