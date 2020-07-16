# frozen_string_literal: true

module TasksHelper
  STATUS_STR = %w[未着手 実施中 完了].freeze

  def to_status_str(str)
    STATUS_STR[str]
  end

  def status_select
    STATUS_STR.map.with_index { |status, index|
      [status, index]
    }.to_h
  end

  def sort_directions
    {
      desc: 'desc',
      asc: 'asc',
    }
  end
end
