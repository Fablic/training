FactoryBot.define do
  factory :task do
    title { 'Test Task' }
    status { 0 }
    priority { 0 }
    user_id { 1 }

    trait :task do
      sequence(:title) { |n| "test#{n}" }
    end
  end
end
