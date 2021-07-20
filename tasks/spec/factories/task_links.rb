FactoryBot.define do
  ActiveRecord::Base.connection.execute('ALTER TABLE task_links AUTO_INCREMENT = 1')
  factory :task_link, class: TaskLink do
    task_id { 1 }
    user_id { 1 }
  end
end
