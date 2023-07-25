FactoryBot.define do
  factory :task do
    name { 'Task' }
    status { 'Not Started' }
    priority { 1 }
    user_id { 1 }

    trait :taskn do
      sequence(:name) { |n| "test#{n}" }
    end
  end
end
