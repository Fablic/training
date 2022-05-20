FactoryBot.define do
  factory :task, class: Task do
    sequence(:title) { |n| "test_title#{n}" }
    sequence(:description) { |n| "test_description#{n}" }
    sequence(:created_at) { |n| "2022/05/18 00:00:#{n}" }
    sequence(:due_date) { |n| "2022/05/18 00:00:#{n}" }
  end
end
