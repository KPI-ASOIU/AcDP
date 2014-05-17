class AddAuthorForeignKeyToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :author_id, :integer
  end
end
