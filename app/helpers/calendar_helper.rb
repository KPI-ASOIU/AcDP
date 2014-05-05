module CalendarHelper
  def calendar(date = Date.today, &block)
    Calendar.new(self, date, block).table
  end

  class Calendar < Struct.new(:view, :date, :callback)
<<<<<<< HEAD
    HEADER = [I18n.t('date.day_names.Monday'), I18n.t('date.day_names.Tuesday'), I18n.t('date.day_names.Wednesday'), I18n.t('date.day_names.Thursday'), I18n.t('date.day_names.Friday'), I18n.t('date.day_names.Saturday'), I18n.t('date.day_names.Sunday')]
=======
    HEADER = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]
>>>>>>> Create calendar template
    START_DAY = :monday

    delegate :content_tag, to: :view

    def table
      content_tag :table, class: "calendar" do
        header + week_rows
      end
    end

    def header
      content_tag :tr do
        HEADER.map { |day| content_tag :th, day }.join.html_safe
      end
    end

    def week_rows
      weeks.map do |week|
        content_tag :tr do
          week.map { |day| day_cell(day) }.join.html_safe
        end
      end.join.html_safe
    end

    def day_cell(day)
      content_tag :td, view.capture(day, &callback), class: day_classes(day)
    end

    def day_classes(day)
      classes = []
      classes << "today" if day == Date.today
      classes << "notmonth" if day.month != date.month
<<<<<<< HEAD
      classes << "past" if day < Date.today
=======
>>>>>>> Create calendar template
      classes.empty? ? nil : classes.join(" ")
    end

    def weeks
      first = date.beginning_of_month.beginning_of_week(START_DAY)
      last = date.end_of_month.end_of_week(START_DAY)
      (first..last).to_a.in_groups_of(7)
    end
  end
end