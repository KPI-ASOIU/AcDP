module TasksHelper
	def checklist_percentage(task)
		checklist = task.checklists
		(checklist.map { |c| c.done ? 1 : 0}).sum * 100 / checklist.length
	end
end
