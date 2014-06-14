class CalendarController < ApplicationController
  before_action :set_current_user

  def calendar
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @tasks_by_date = Task.connected_to_me.group_by{ |item| item.end_date ? item.end_date.to_date : nil }
  end

  def day
    date_start = Time.parse(params[:date]) #midnight of date
    date_finish = date_start + 1.day
    @tasks = Task.where{(end_date >= date_start) & (end_date <= date_finish)}
  end
end
