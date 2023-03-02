module TaskHelper
  def options_for_select_of_statuses
    Task.statuses.map{|i| [I18n.t(i[0], scope: [:activerecord, :attributes, :task, :statuses]), i[1]]}
  end

  def value_with_i18n(task, column_name)
    return I18n.t(task.status, scope: [:activerecord, :enums, :task, :status]) if column_name == 'status'
    task.send(column_name)
  end
end
