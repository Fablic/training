module TasksHelper
  def translate_priority(priority)
    return t("activerecord.enum.task.priority.#{Task.prioritys.invert[priority]}") if Task.prioritys.value?(priority)

    raise "Unexpected priority `#{priority}` is set."
  end

  def translate_status(status)
    return t("activerecord.enum.task.status.#{Task.statuses.invert[status]}") if Task.statuses.value?(status)

    raise "Unexpected status `#{status}` is set."
  end
end
