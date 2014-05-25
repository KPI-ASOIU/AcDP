module EventsHelper
	def any_authored_events(events)
		events.each { |e| return true if e.author == current_user}
		false
	end

	def events_not_authored_by_me
		Event.all.map { |e| e.author.id }.uniq.reject { |id| id == current_user.id }.join(" ")
	end

	def all_authors_of_my_events
		current_user.visiting_events.map { |e| [e.author.full_name, e.author.id] }
			.uniq.reject{ |e| e[1] == current_user.id }
	end

	def events_not_visited_by_me
		Event.all.map { |e| e.guests.pluck(:id) }.flatten.uniq
        	.reject { |guest| guest == current_user.id }.join(" ")
	end

	def all_visitors
		Event.all.map { |e| e.guests }.uniq.flatten.reject{ |u| u == current_user }.map { |v| [v.full_name, v.id] }
	end
end
