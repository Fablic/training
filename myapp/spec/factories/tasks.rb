FactoryBot.define do
  factory :task, class: Task do
    sequence(:task_name) { |n| "Task_name#{n}" }
    sequence(:description) { |n| "Description#{n}" }
    sequence(:priority) { |n| "#{n}" }
    start_date { Time.now }
    end_date   { Time.now }
  end
end
