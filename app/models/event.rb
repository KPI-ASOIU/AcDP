class Event < ActiveRecord::Base
	belongs_to :author, class_name: "User"
	has_and_belongs_to_many :guests, 
	  	class_name: "User", 
	  	join_table: :events_has_guests, 
	    association_foreign_key: :guest_id

	scope :with_name, ->(name) { where("name LIKE ?", "%#{name}%") }
  scope :with_place, ->(place) { where("place LIKE ?", "%#{place}%") }
  scope :with_author, ->(authors) { where(author_id: authors) }
  scope :with_guests, ->(guests) { joins(:guests).where("events_has_guests.guest_id" => guests) }
  scope :with_date, ->(date1, date2) { where(date: date1..date2) }
  scope :created_at, ->(date1, date2) { where(created_at: date1..date2) }

	opinio_subjectum
end
