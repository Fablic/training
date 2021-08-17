FactoryBot.define do
  factory :task_link, class: TaskLink do
    task_id { 1 }
    user_id { 1 }
  end
end
