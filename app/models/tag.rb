class Tag < ActiveRecord::Base
	validates :name, uniqueness: true
	has_and_belongs_to_many :tasks, join_table: :task_has_tags
end
