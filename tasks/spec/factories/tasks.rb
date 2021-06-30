FactoryBot.define do
  ActiveRecord::Base.connection.execute('ALTER TABLE tasks AUTO_INCREMENT = 1')
  factory :task, class: Task do
    initialize_with do
      Task.find_or_initialize_by(
        id: 1,
        task_name: 'テストタスク名',
        status: create(:notStarted),
        priority: create(:low)
      )
    end
  end
end
