class CalendarController < ApplicationController
  def calendar
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @tasks_by_date = (current_user.executing_tasks | current_user.leading_tasks).group_by{ |item| item.end_date ? item.end_date.to_date : nil }
  end
end
