module TasksHelper
	def checklist_percentage(task)
		checklist = task.checklists
		(checklist.map { |c| c.done ? 1 : 0}).sum * 100 / checklist.length
	end

	def status_class(status)
		case status
		when "Done"
			"text-success"
		when "Active"
			"text-primary"
		when "Undone"
			"text-danger"
		when "Frozen"
			"text-muted"
		end
	end

	def any_checklists(tasks)
		tasks.each { |t| return true if t.checklists != nil } 
		false
	end

	def any_authored_tasks(tasks)
		tasks.each { |t| return true if t.author == current_user}
		false
	end
end
