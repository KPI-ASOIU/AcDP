class CreateEventsHasGuests < ActiveRecord::Migration
  def change
    create_table :event_has_guests do |t|
    	t.integer :event_id
    	t.integer :guest_id
    end
  end
end
