FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "Task#{n}" }
    sequence(:description) { |n| "Description#{n}" }
    status { "In Progress" }
    priority { "High" }
    duedate { "2024-06-08" }
    created_at { Time.now }
    updated_at { Time.now }
    association :user
  end
end
