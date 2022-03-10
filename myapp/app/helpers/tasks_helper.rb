module TasksHelper
  def task_submit_title
    t("tasks.#{params[:action]}.submit")
  end

  def show_labels(label_id)
    return '' if label_id.blank?
    show_labels = ''
    label_id.split(',').each do | l |
      # show_labels.concat("#{@labels[l.to_i]} ")
      label = @labels[l.to_i]
      show_labels.concat("<span class=\"task-label\" style=\"color:#{label.color};background-color:#{label.bgcolor};\">#{label.label}</span> ")
    end
    return show_labels
  end
end
