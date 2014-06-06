class AddCustomFieldToActivities < ActiveRecord::Migration
  def change
  	change_table :activities do |t|
      t.text :connected_to_users
    end
  end
end
