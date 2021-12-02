# frozen_string_literal: true

module TasksHelper
  def sort_order(column, title)
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'

    link_to title, { sort: column, direction: direction }
  end

  def direction_arrow(column)
    return sort_direction == 'asc' ? '↑' : '↓' if column == sort_column
  end
end
