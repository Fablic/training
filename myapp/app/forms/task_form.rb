class TaskForm
    include ActiveModel::Model

    attr_accessor(
      :title,
      :description,
      :status,
      :user_id,
      :label1,
      :label2,
      :label3,
      :label4,
      :label5,
    )

    def setting(id)
      task = Task.find(id)
      labels = Label.all.where(task_id: task.id)

      self.title = task.title
      self.description = task.description
      self.status = task.status
      self.user_id = task.user_id
      self.label1 = labels[0].name if labels.present? && labels.size > 0
      self.label2 = labels[1].name if labels.present? && labels.size > 1
      self.label3 = labels[2].name if labels.present? && labels.size > 2
      self.label4 = labels[3].name if labels.present? && labels.size > 3
      self.label5 = labels[4].name if labels.present? && labels.size > 4
    end

    def save
      begin
        ActiveRecord::Base.transaction do
          @task = Task.new(title: self.title, description: self.description, status: self.status.present? ? self.status : Task.statuses[:not_started], user_id: self.user_id)
          @task.save!
          @labels = []
          @labels.push(Label.new(name: self.label1, task_id: @task.id)) if !self.label1.blank?
          @labels.push(Label.new(name: self.label2, task_id: @task.id)) if !self.label2.blank?
          @labels.push(Label.new(name: self.label3, task_id: @task.id)) if !self.label3.blank?
          @labels.push(Label.new(name: self.label4, task_id: @task.id)) if !self.label4.blank?
          @labels.push(Label.new(name: self.label5, task_id: @task.id)) if !self.label5.blank?
          @labels.each { |label| !label.save! }
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
          @task.update!(title: self.title, description: self.description, status: self.status, user_id: self.user_id)

          @labels = []
          Label.all.where(task_id: @task.id).destroy_all
          @labels.push(Label.new(name: self.label1, task_id: @task.id)) if !self.label1.blank?
          @labels.push(Label.new(name: self.label2, task_id: @task.id)) if !self.label2.blank?
          @labels.push(Label.new(name: self.label3, task_id: @task.id)) if !self.label3.blank?
          @labels.push(Label.new(name: self.label4, task_id: @task.id)) if !self.label4.blank?
          @labels.push(Label.new(name: self.label5, task_id: @task.id)) if !self.label5.blank?
          @labels.each { |label| !label.save! }
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

      error_messages.uniq
    end
  end
