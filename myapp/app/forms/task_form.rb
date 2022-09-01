class TaskForm
  include ActiveModel::Model

  attr_accessor(
    :title,
    :content,
    :status,
    :user_id,
    :label1,
    :label2,
    :label3,
    :label4,
    :label5,
  )

  def save
      @task = Task.new(title: self.title, content: self.content, status: self.status.present? ? self.status : Task.statuses[:not_started], user_id: self.user_id)
      ret_task = @task.save

      ret_labels = true
      if ret_task
        @labels = []
        @labels.push(Label.new(name: self.label1, task_id: @task.id)) if !self.label1.blank?
        @labels.push(Label.new(name: self.label2, task_id: @task.id)) if !self.label2.blank?
        @labels.push(Label.new(name: self.label3, task_id: @task.id)) if !self.label3.blank?
        @labels.push(Label.new(name: self.label4, task_id: @task.id)) if !self.label4.blank?
        @labels.push(Label.new(name: self.label5, task_id: @task.id)) if !self.label5.blank?
        @labels.each { |label| ret_labels = false if !label.save }
      end

      ret_task && ret_labels
  end

  def update!(id)
    @task = Task.find(id).update!(title: self.title, content: self.content, status: self.status, user_id: self.user_id)
    Label.find(task_id: task.id).delete
    Label.save!(name: label1, task_id: task.id) if label1
    Label.save!(name: label2, task_id: task.id) if label2
    Label.save!(name: label3, task_id: task.id) if label3
    Label.save!(name: label4, task_id: task.id) if label4
    Label.save!(name: label5, task_id: task.id) if label5
  end

  def error_messages
    error_messages = []
    @task.errors.full_messages.each { |msg| error_messages.push(msg) } if @task.present? && @task.errors.any?
    @labels.each { |label| label.errors.full_messages.each { |msg| error_messages.push(msg) } if label.errors.any? } if @labels.present?

    error_messages
  end
end
