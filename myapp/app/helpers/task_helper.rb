module TaskHelper
  def status_label(task)
    case task.status
    when 'pending'
      content_tag(:span, t('views.selects.status_pending'), class: 'status-label pending')
    when 'in_progress'
      content_tag(:span, t('views.selects.status_in_progress'), class: 'status-label in-progress')
    when 'completed'
      content_tag(:span, t('views.selects.status_completed'), class: 'status-label completed')
    end
  end
end
