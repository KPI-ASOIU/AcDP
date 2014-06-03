class DropTagsConnectedTables < ActiveRecord::Migration
  def change
  	drop_table :tags
  	drop_table :task_has_tags
  end
end
