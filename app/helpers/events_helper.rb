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

	def can_all_visit?(event)
		visiting_status = EventHasGuest.where(event_id: event.id).pluck(:status)
		visiting_status.sum == visiting_status.length
	end

	def all_not_visiting(event)
		User.where(id: EventHasGuest.where(event_id: event.id, status: 0).pluck(:guest_id))
	end

	def visit?(event)
		EventHasGuest.where(event_id: event.id, guest_id: current_user.id).pluck(:status).first != 0
	end
end
