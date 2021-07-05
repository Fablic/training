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
  factory :task_list_item, class: Task do
    task_name { 'テストタスク名' }
    status { create(:notStarted) }
    priority { create(:low) }
  end
  factory :exist_limit_date_task, class: Task do
    task_name { 'テストタスク名' }
    status { create(:notStarted) }
    priority { create(:low) }
    limit_date { Time.current + 1.minute }
  end
end
