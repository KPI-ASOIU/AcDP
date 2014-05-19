class AddStatusColumnToEventHasGuests < ActiveRecord::Migration
  def change
  	add_column :event_has_guests, :status, :integer, default: 1
  end
end
