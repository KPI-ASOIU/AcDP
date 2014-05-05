class CalendarController < ApplicationController
  def calendar
  	@date = params[:date] ? Date.parse(params[:date]) : Date.today
  end
end
