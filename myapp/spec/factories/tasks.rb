FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "Testing#{n}" }
    sequence(:description) { |n| "Testing of the app#{n}" }
    status { "In Progress" }
    priority { "High" }
    duedate { "2024-06-08" }
    created_at { Time.now }
    updated_at { Time.now }
  end
end
