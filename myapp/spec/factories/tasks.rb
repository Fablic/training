FactoryBot.define do
  factory :task, class: Task do
    sequence(:title) { |n| "Task#{n}" }
    sequence(:description) { |n| "Description#{n}" }
    sequence(:status) { Task.statuses.keys[0] }
  end

  factory :blank_task, class: Task do
    title       { '' }
    description { '' }
    status      { Task.statuses.keys[0] }
  end
end
