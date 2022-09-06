# frozen_string_literal: true

module CommonHelper
  def time_zone(date_time)
    date_time.strftime('%Y/%m/%d %H:%M')
  end
end
