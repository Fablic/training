module TasksHelper
  def options_for_select_of_statuses
    Task.statuses.keys.map { |status| [I18n.t(status, scope: [:activerecord, :enums, :task, :status]), status] }
  end

  # see: http://taustation.com/rails-reflecting-newline-code/
  def html_safe_with_line_break(str)
    h(str).gsub(/\n|\r|\r\n/, '<br>').html_safe
  end

  def badge_class(status)
    class_name = 'badge py-2 fs-6 '
    class_name += case status
                  when 'unstarted'
                    'bg-primary'
                  when 'wip'
                    'bg-danger'
                  when 'done'
                    'bg-success'
                  else
                    'bg-secondary'
                  end
    class_name
  end
end
