# This model is responsible for validating filter conditions and executing filtering.
class TaskFilterer
  include ActiveModel::Model

  validates :name, length: { maximum: 50 }
  validates :status, inclusion: { in: Task.statuses.keys }, allow_blank: true

  attr_accessor :name, :status

  def execute(tasks)
    tasks = tasks.send(status) if status.present?
    tasks = tasks.name_contain(name) if name.present?
    tasks
  end
end
