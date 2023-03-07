module TasksHelper
  def options_for_select_of_statuses
    Task.statuses.keys.map { |status| [I18n.t(status, scope: [:activerecord, :enums, :task, :status]), status] }
  end

  def value_with_i18n_line_break(task, column_name)
    return I18n.t(task.status, scope: [:activerecord, :enums, :task, :status]) if column_name == 'status'
    return html_safe_with_line_break(task.description) if column_name == 'description'

    task.send(column_name)
  end

  # see: http://taustation.com/rails-reflecting-newline-code/
  def html_safe_with_line_break(str)
    h(str).gsub(/\n|\r|\r\n/, "<br>").html_safe
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
