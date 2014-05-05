class AddForeignTaskForeignKeyToUsers < ActiveRecord::Migration
  def change
    add_column(:users, :task_id, :integer)
  end
end
