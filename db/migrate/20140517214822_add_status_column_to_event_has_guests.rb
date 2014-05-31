class AddStatusColumnToEventHasGuests < ActiveRecord::Migration
  def change
  	add_column :events_has_guests, :status, :integer, default: 1
  end
end
