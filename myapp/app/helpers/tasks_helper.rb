module TasksHelper
  def options_for_select_of_statuses
    Task.statuses.keys.map { |status| [I18n.t(status, scope: [:activerecord, :enums, :task, :status]), status] }
  end

  def value_with_i18n(task, column_name)
    return I18n.t(task.status, scope: [:activerecord, :enums, :task, :status]) if column_name == 'status'

    task.send(column_name)
  end
end
