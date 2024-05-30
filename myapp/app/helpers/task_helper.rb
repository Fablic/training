module TaskHelper
  def status_label(task)
    case task.status
    when 'pending'
      content_tag(:span, 'Pending', class: 'status-label pending')
    when 'in_progress'
      content_tag(:span, 'In Progress', class: 'status-label in-progress')
    when 'completed'
      content_tag(:span, 'Completed', class: 'status-label completed')
    end
  end
end
