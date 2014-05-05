class CreateExecutingTasksExecutors < ActiveRecord::Migration
  def change
    create_table :executing_tasks_executors do |t|
      t.integer :task_id
      t.integer :executor_id
    end
  end
end
