# Using Struct to mock the model without database
class Calendar < Struct.new(:view, :date, :callback)
  HEADER = %w[日 月 火 水 木 金 土].freeze
  START_DAY = :sunday

  # using delefate to avoid duplicate calling view.content_tag
  delegate :content_tag, to: :view

  def table
    content_tag :table, class: "calendar table table-bordered" do
      header + week_rows
    end
  end

  # the header row of the calendar
  def header
    content_tag :tr do
      HEADER.map { |week_day| content_tag :th, week_day, class: header_classes(week_day) }.join.html_safe
    end
  end

  # the date row of the calendar
  def week_rows
    weeks.map do |week|
      content_tag :tr do
        week.map { |day| day_cell(day) }.join.html_safe
      end
    end.join.html_safe
  end

  # the date of the calendar
  def day_cell(day)
    content_tag :td, view.capture(day, &callback), class: day_classes(day)
  end

  # Checking The day is today for Thats day doesn't belongs to this month
  def day_classes(day)
    classes = []
    classes << 'today' if day == Date.today
    classes << 'not-month' if day.month != date.month
    classes << 'holiday' if day.saturday? || day.sunday?
    classes.empty? ? nil : classes.join(' ')
  end

  def header_classes(week_day)
    classes = []
    classes << 'header'
    classes << 'holiday_weekday' if week_day == '日' || week_day == '土'
    classes.empty? ? nil : classes.join(' ')
  end

  def weeks
    first = date.beginning_of_month.beginning_of_week(START_DAY)
    last = date.end_of_month.end_of_week(START_DAY)
    (first..last).to_a.in_groups_of(7)
  end

end
