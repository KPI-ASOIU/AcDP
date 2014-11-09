module TasksHelper
	def checklist_percentage(task)
		checklist = task.checklists
		((checklist.map { |c| c.done ? 1 : 0}).sum * 100 / checklist.length.to_f).round(2)
	end

	def icon_status_class(status)
		case status
		when "Done"
			"ui checkmark sign icon"
		when "Active"
			"ui loading icon"
		when "Undone"
			"ui attention icon"
		when "Frozen"
			"ui warning icon"
		else
			""
		end
	end

	def status_class(status)
		case status
		when "Done"
			"ui success message"
		when "Active"
			"ui info message"
		when "Undone"
			"ui error message"
		when "Frozen"
			"ui warning message"
		else
			"ui message"
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
		Task.all.map { |t| t.executors }.flatten.reject{ |u| u == current_user }.map { |e| [e.full_name, e.id] }.uniq
	end

	def translate_statuses(statuses)
		statuses.map { |status| [t('tasks.statuses.' + status), []] } 
	end

	def translate_status(status)
		t('tasks.statuses.' + status)
	end

	def belongs_to?(task)
		task.executors.include?(current_user)
	end

	def authored_any_task?(tasks)
		tasks.any? { |t| t.author == current_user }
	end
end
