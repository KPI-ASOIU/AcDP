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

	def tasks_not_authored_by_me
		Task.all.map { |t| t.author.id }.uniq.reject { |id| id == current_user.id }.join(" ")
	end

	def all_authors_of_my_tasks
		current_user.executing_tasks.map { |t| [t.author.full_name, t.author.id] }
			.uniq.reject{ |t| t[1] == current_user.id }
	end

	def tasks_not_executed_by_me
		Task.all.map { |t| t.executors.pluck(:id) }.flatten.uniq
        	.reject { |exec| exec == current_user.id }.join(" ")
	end

	def all_executors
		Task.all.map { |t| t.executors }.uniq.flatten.reject{ |u| u == current_user }.map { |e| [e.full_name, e.id] }
	end

	def translate_statuses(statuses)
		statuses.map { |status| [t('tasks.statuses.' + status), []] } 
	end

	def translate_status(status)
		t('tasks.statuses.' + status)
	end

	def local_time_convert(time)
	    DateTime.strptime(time, I18n.l('time.formats.short'))
	end
end
