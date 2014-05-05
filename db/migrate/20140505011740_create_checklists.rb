class CreateChecklists < ActiveRecord::Migration
  def change
    create_table :checklists do |t|
      t.boolean :done
      t.string :name
      t.integer :task_id

      t.timestamps
    end
  end
end
