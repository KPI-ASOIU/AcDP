class Task < ActiveRecord::Base
  belongs_to :author, class_name: "User", foreign_key: :user_id

  has_and_belongs_to_many :executors, 
	  	class_name: "User", 
	  	join_table: :executing_tasks_executors, 
	    foreign_key: :task_id, 
	    association_foreign_key: :executor_id

  has_and_belongs_to_many :tags, join_table: :task_has_tags
  has_many :checklists
  accepts_nested_attributes_for :checklists, allow_destroy: true

  STATUS = ["Active".freeze, "Frozen".freeze, "Done".freeze, "Undone".freeze]

  serialize :check_list, Array

  scope :with_name, ->(name) { where("name LIKE ?", "%#{name}%") }
  scope :with_status, ->(status) { where(status: status) }
  scope :with_author, ->(authors) { where(user_id: authors) }
  scope :with_executors, ->(executors) { joins(:executors).where("executing_tasks_executors.executor_id" => executors) }
  scope :with_end_date, ->(date1, date2) { where(end_date: date1..date2) }
  scope :created_at, ->(date1, date2) { where(created_at: date1..date2) }

  validates_presence_of :name

  opinio_subjectum

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user },
          params: {
            summary: Proc.new { |controller, model| model.name.truncate(30) },   # by default save truncated summary of the post's body
            trackable_id: Proc.new {|controller, model| model.id },
            connected_to_users: Proc.new { |controller, model| 
              [model.author.id].concat(model.executors.map { |e| e.id }) 
            }
          }
end

