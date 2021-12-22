module TasksHelper
  def sort_order(column, title)
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to title, { sort: column, direction: direction }, id: "tasks_#{column}_link"
  end

  def label_checked?(label_id)
    label_params = params[:label]
    return false if label_params.blank?

    label_params.value?(label_id.to_s)
  end

  def label_names(task)
    labels = task.labels
    return '' if labels.includes([:task_labels]).blank?

    label_names = labels.includes([:task_labels]).map(&:name)
    label_names.join(', ')
  end
end
