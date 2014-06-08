class Event < ActiveRecord::Base
	belongs_to :author, class_name: "User"
	has_many :event_has_guests
	has_many :guests, 
			through: :event_has_guests,
			source: :guest

  scope :connected_to_me, -> { joins('LEFT JOIN event_has_guests ON events.id = event_has_guests.event_id')
    .where("author_id = ? OR event_has_guests.guest_id = ?", User.current.id, User.current.id) }
	scope :with_name, ->(name) { where("name LIKE ?", "%#{name}%") }
  scope :with_place, ->(place) { where("place LIKE ?", "%#{place}%") }
  scope :with_author, ->(authors) { where(author_id: authors) }
  scope :with_guests, ->(guests) { where("event_has_guests.guest_id" => guests) }
  scope :with_date, ->(date1, date2) { where(date: date1..date2) }
  scope :created_at, ->(date1, date2) { where(created_at: date1..date2) }

  validates_presence_of :name

	opinio_subjectum

 	include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user },
  		    params: {
            summary: Proc.new {|controller, model| model.name.truncate(30)},
            trackable_id: Proc.new {|controller, model| model.id }
          },
          connected_to_users: Proc.new { |controller, model|
            ' ' << [model.author.id].concat(model.guests.map { |e| e.id }.uniq) * (' ') << ' '
          }
end
