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

  def setting(id)
    task = Task.eager_load(:labels).includes(:task_labels).find(id)

    self.title = task.title
    self.content = task.content
    self.status = task.status
    self.user_id = task.user_id
    self.label1 = task.labels[0].id if task.labels.present? && task.labels.size > 0
    self.label2 = task.labels[1].id if task.labels.present? && task.labels.size > 1
    self.label3 = task.labels[2].id if task.labels.present? && task.labels.size > 2
    self.label4 = task.labels[3].id if task.labels.present? && task.labels.size > 3
    self.label5 = task.labels[4].id if task.labels.present? && task.labels.size > 4
  end

  def save
    begin
      ActiveRecord::Base.transaction do
        @task = Task.new(title: self.title, content: self.content, status: self.status.present? ? self.status : Task.statuses[:not_started], user_id: self.user_id)
        @task.save!

        uniqueness_label
        @task_labels = []
        @task_labels.push(TaskLabel.new(task_id: @task.id, label_id: self.label1)) if self.label1.present?
        @task_labels.push(TaskLabel.new(task_id: @task.id, label_id: self.label2)) if self.label2.present?
        @task_labels.push(TaskLabel.new(task_id: @task.id, label_id: self.label3)) if self.label3.present?
        @task_labels.push(TaskLabel.new(task_id: @task.id, label_id: self.label4)) if self.label4.present?
        @task_labels.push(TaskLabel.new(task_id: @task.id, label_id: self.label5)) if self.label5.present?
        @task_labels.each { |task_label| !task_label.save! }
      end
      return true
    rescue
      return false
    end
  end

  def update(id)
    begin
      ActiveRecord::Base.transaction do
        @task = Task.find(id)
        @task.update!(title: self.title, content: self.content, status: self.status, user_id: self.user_id)

        uniqueness_label
        @task_labels = []
        TaskLabel.all.where(task_id: @task.id).destroy_all
        @task_labels.push(TaskLabel.new(task_id: @task.id, label_id: self.label1)) if self.label1.present?
        @task_labels.push(TaskLabel.new(task_id: @task.id, label_id: self.label2)) if self.label2.present?
        @task_labels.push(TaskLabel.new(task_id: @task.id, label_id: self.label3)) if self.label3.present?
        @task_labels.push(TaskLabel.new(task_id: @task.id, label_id: self.label4)) if self.label4.present?
        @task_labels.push(TaskLabel.new(task_id: @task.id, label_id: self.label5)) if self.label5.present?
        @task_labels.each { |task_label| !task_label.save! }
      end
      return true
    rescue
      return false
    end
  end

  def error_messages
    error_messages = []
    @task.errors.full_messages.each { |msg| error_messages.push(msg) } if @task.present? && @task.errors.any?
    @labels.each { |label| label.errors.full_messages.each { |msg| error_messages.push(msg) } if label.errors.any? } if @labels.present?
    error_messages
  end

  private

  def uniqueness_label
    labels = []
    labels.push(self.label1)
    labels.push(self.label2)
    labels.push(self.label3)
    labels.push(self.label4)
    labels.push(self.label5)
    labels = labels.uniq

    self.label1 = labels.size > 0 ? labels[0] : ''
    self.label2 = labels.size > 1 ? labels[1] : ''
    self.label3 = labels.size > 2 ? labels[2] : ''
    self.label4 = labels.size > 3 ? labels[3] : ''
    self.label5 = labels.size > 4 ? labels[4] : ''
  end
end
