FactoryBot.define do
  factory :task do
    title { 'Test Task' }
    status { 0 }
    priority { 0 }
    user_id { 1 }
    user_type { 'Task' }

    trait :task do
      sequence(:title) { |n| "test#{n}" }
    end
  end
end
