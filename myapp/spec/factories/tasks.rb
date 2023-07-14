FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "Task#{n}" }
    sequence(:description) { |n| "Description#{n}" }
    status { 1 }
    priority { 1 }
    expired_date { 1.week.from_now }
    created_at { Time.now }
    updated_at { Time.now }
    association :user
  end
end
