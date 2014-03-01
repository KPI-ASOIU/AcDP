class Group < ActiveRecord::Base
	validates :name, :start_year, :graduation_year, :speciality, :speciality_code, :full_time, :degree, presence: true
	validates :start_year, numericality: {greater_than: 0}
	validates :graduation_year, numericality: {greater_than: :start_year}
end
