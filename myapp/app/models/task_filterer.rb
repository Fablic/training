class TaskFilterer
  include ActiveModel::Model

  validates :name, length: { maximum: 50 }
  # TODO: status list のベタ書きやめる
  validates :status, inclusion: { in: %w(unstarted wip done) }, allow_blank: true

  attr_accessor :name, :status

  def execute(tasks)
    tasks = tasks.send(status) if status.present?
    tasks.name_contain(name) if name.present?
    tasks
  end
end
