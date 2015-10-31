class CalendarController < ApplicationController
  before_action :set_current_user

  def calendar
    if can? :crud, Task
      @my_tasks = Task.connected_to_me.uniq.all
    end
    @my_events = Event.connected_to_me.uniq.all
  end

  def day
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    date_start = Time.parse(params[:date]) #midnight of date
    date_finish = date_start + 1.day
    if can? :crud, Task
      @tasks = Task.connected_to_me.uniq.where{(end_date >= date_start) & (end_date <= date_finish)}
    end
    @events = Event.connected_to_me.uniq.where{(date >= date_start) & (date <= date_finish)}
  end
end
