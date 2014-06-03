class RenameEventsHasGuestsTable < ActiveRecord::Migration
  def change
  	rename_table :events_has_guests, :event_has_guests
  end
end
