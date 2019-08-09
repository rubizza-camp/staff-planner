# frozen_string_literal: true

class WorkingDayDecorator < SimpleDelegator
  def display_day_of_week
    Date::DAYNAMES[day_of_week]
  end
end
