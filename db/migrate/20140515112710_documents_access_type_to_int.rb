class DocumentsAccessTypeToInt < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE user_has_accesses ALTER COLUMN access_type TYPE integer USING (access_type::integer)'
    rename_column :user_has_accesses, :date_created, :created_at
  end

  def down
    execute 'ALTER TABLE user_has_accesses ALTER COLUMN access_type TYPE text USING (access_type::text)'
    rename_column :user_has_accesses, :created_at, :date_created
  end
end
