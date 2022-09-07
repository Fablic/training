# frozen_string_literal: true

module ApplicationHelper
  def time_zone(date_time)
    date_time.strftime('%Y/%m/%d %H:%M')
  end
end
