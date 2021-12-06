# frozen_string_literal: true

module TasksHelper
  def sort_order(column, title)
    (direction = column == sort_column && sort_direction == 'asc') ? 'desc' : 'asc'

    link_to title, { sort: column, direction: direction }
  end

  def direction_arrow(column)
    return sort_direction == 'asc' ? '↑' : '↓' if column == sort_column
  end

  def translate_priority(priority)
    return if priority.nil?
    return I18n.t("enums.task.priority.#{priority}") if Task.priorities.keys.include?(priority)
  end

  def translate_status(status)
    return if status.nil?
    return I18n.t("enums.task.status.#{status}") if Task.statuses.keys.include?(status)
  end
end
