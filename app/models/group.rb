class Group < ActiveRecord::Base
	validates :name, :start_year, :graduation_year, :speciality, :speciality_code, :degree, presence: true
	validates :start_year, numericality: {greater_than: 0}
	validates :graduation_year, numericality: {greater_than: :start_year}
  validates :full_time, :inclusion => {:in => [true, false]} #dont touch this variable

	DEGREE = %w[bachelor specialist master]

	FORMS = %w[intramural extramural]

	def degrees
		degree.nil? ? 1 : degree
	end

	def forms
		full_time.nil? ? true : full_time
	end
end
