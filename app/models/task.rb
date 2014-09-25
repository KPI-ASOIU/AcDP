class Task < ActiveRecord::Base
  belongs_to :author, class_name: "User", foreign_key: :user_id

  has_and_belongs_to_many :executors, 
	  	class_name: "User", 
	  	join_table: :executing_tasks_executors, 
	    foreign_key: :task_id, 
	    association_foreign_key: :executor_id

  has_many :checklists, -> { order 'created_at' }
  accepts_nested_attributes_for :checklists, allow_destroy: true

  STATUS = ["Active".freeze, "Frozen".freeze, "Done".freeze, "Undone".freeze]

  serialize :check_list, Array

  scope :connected_to_me, -> { joins('LEFT JOIN executing_tasks_executors ON tasks.id = executing_tasks_executors.task_id')
    .where("user_id = ? OR executing_tasks_executors.executor_id = ?", User.current.id, User.current.id) }
  scope :with_name, ->(name) { where("name LIKE ?", "%#{name}%") }
  scope :with_status, ->(status) { where(status: status) }
  scope :with_author, ->(authors) { where(user_id: authors) }

  # with_executors scope can only be applied after scope or query containing join with executing_tasks_executors
  # or joins(:executors) using ActiveRecord ORM
  scope :with_executors, ->(executors) { where("executing_tasks_executors.executor_id" => executors) }

  scope :with_end_date, ->(date1, date2) { where(end_date: date1..date2) }
  scope :created_at, ->(date1, date2) { where(created_at: date1..date2) }

  validates_presence_of :name

  opinio_subjectum

  include PublicActivity::Model

  tracked only: [:destroy, :create], 
          owner: Proc.new{ |controller, model| controller.current_user },
          params: {
            summary: Proc.new { |controller, model| model.name.truncate(30) },   # by default save truncated summary of the post's body
            trackable_id: Proc.new {|controller, model| model.id },
          },
          connected_to_users: Proc.new { |controller, model| 
            ' ' << [model.author.id].concat(model.executors.map { |e| e.id }) * (' ') << ' '
          }
end

