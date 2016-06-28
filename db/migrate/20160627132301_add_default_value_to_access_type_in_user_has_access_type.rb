class AddDefaultValueToAccessTypeInUserHasAccessType < ActiveRecord::Migration
  def change
    change_column :user_has_accesses, :access_type, :integer, :default => 0
  end
end
