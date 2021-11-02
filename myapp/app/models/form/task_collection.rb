class Form::TaskCollection
  include ActiveModel::Model
  include ActiveModel::Callbacks
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks

  attr_reader :task

  def initialize(task)
    task.label = task.labels.pluck(:label).join(',') if task.labels.present?
    @task = task
  end

  def save(params)
    Task.transaction do
      @task.image.attach(params[:image])
      @task.labels = labels(params).map(&:strip).map { |l| Label.where(label: l).first_or_create }
      @task.save!
    end
    true
  rescue StandardError
    false
  end

  def update(params)
    labels = labels(params)
    Task.transaction do
      @task.image.attach(params[:image])
      TaskLabel.where(task_id: @task.id).where.not(label_id: Label.where(label: labels)).destroy_all
      params[:labels] = labels.map { |label| Label.where(label: label).first_or_create }
      @task.update!(params)
    end
    true
  rescue StandardError
    false
  end

  private

  def labels(params)
    params[:label].split(',').map(&:strip)
  end
end
