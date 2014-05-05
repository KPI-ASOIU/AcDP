class RemoveCheckListFromTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :check_list, :text
  end
end
