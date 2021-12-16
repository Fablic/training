FactoryBot.define do
  factory :task do
    user_id { 1 }
    title { "Do something" }
    description { Faker::Lorem.paragraph }
    priority { Faker::Number.between(from: 0, to: 2) }
    status { Faker::Number.between(from: 0, to: 2) }
    due_datetime { Faker::Time.forward(days: 10) }
  end
end
