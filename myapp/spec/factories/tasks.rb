FactoryBot.define do
  factory :task, class: Task do
    sequence(:title) { |n| "Task#{n}"}
    sequence(:description) { |n| "Description#{n}"}
  end

  factory :blank_task, class: Task do
    title       { '' }
    description { '' }
  end
end
