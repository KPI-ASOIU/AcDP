class RemoveTaskIdFromUsers < ActiveRecord::Migration
  def change
  	remove_column :users, :task_id
  end
end
