# frozen_string_literal: true

module TasksHelper
  def no_of_tasks(user_id)
    # TODO: exclude Done tasks
    Task.where(assignee: user_id).count
  end

  def render_labels(labels)
    labels.tr('["]', '').split(',')
  end
end
