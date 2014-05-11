class Checklist < ActiveRecord::Base
  belongs_to :task
  validates_presence_of :name

  def empty?
  	self.name.nil? || self.name.empty? || self.id.nil?
  end
end
