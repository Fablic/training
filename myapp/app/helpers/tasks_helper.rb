# frozen_string_literal: true

module TasksHelper
  def task_priority_enum_to_ja(priority)
    Task.priorities_i18n[priority]
  end

  def task_status_enum_to_ja(status)
    Task.statuses_i18n[status]
  end
end
