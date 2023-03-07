module TasksHelper
  def options_for_select_of_statuses
    Task.statuses.keys.map { |status| [I18n.t(status, scope: [:activerecord, :enums, :task, :status]), status] }
  end

  def value_with_i18n(task, column_name)
    return I18n.t(task.status, scope: [:activerecord, :enums, :task, :status]) if column_name == 'status'

    task.send(column_name)
  end

  def badge_class(status)
    class_name = 'badge py-2 fs-6 '
    case status
    when 'unstarted'
      class_name += 'bg-primary'
    when 'wip'
      class_name += 'bg-danger'
    when 'done'
      class_name += 'bg-success'
    else
      class_name += 'bg-secondary'
    end
    class_name
  end
end
