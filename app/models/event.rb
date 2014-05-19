class Event < ActiveRecord::Base
	belongs_to :author, class_name: "User"
	has_many :event_has_guests
	has_many :guests, 
			through: :event_has_guests,
			source: :guest

	scope :with_name, ->(name) { where("name LIKE ?", "%#{name}%") }
  scope :with_place, ->(place) { where("place LIKE ?", "%#{place}%") }
  scope :with_author, ->(authors) { where(author_id: authors) }
  scope :with_guests, ->(guests) { joins(:guests).where("events_has_guests.guest_id" => guests) }
  scope :with_date, ->(date1, date2) { where(date: date1..date2) }
  scope :created_at, ->(date1, date2) { where(created_at: date1..date2) }

	opinio_subjectum

 	include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
end
