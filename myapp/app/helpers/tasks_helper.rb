module TasksHelper
  def task_submit_title
    t("tasks.#{params[:action]}.submit")
  end

  def show_labels(label_ids)
    return '' if label_ids.blank?
    show_labels = []
    label_ids.split(',').each do | l |
      show_labels.push(show_label(l.to_i))
    end
    show_labels.join(' ')
  end

  def show_label(label_id)
    label = @task_labels[label_id]
    "<span class=\"task-label\" style=\"color:#{label.color};background-color:#{label.bgcolor};\">#{label.label}</span>"
  end
end
