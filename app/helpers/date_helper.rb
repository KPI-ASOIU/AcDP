module DateHelper
	def local_time_convert(time)
    DateTime.strptime(time, I18n.t('time.formats.short'))
  end

  def local_time_format(time)
    I18n.l(time, format: :short)
  end

  def time_diff(time1, time2)
  	Time.diff(Time.now, Time.parse(local_time_format(item.end_date)))
  end
end
