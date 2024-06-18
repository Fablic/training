FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence }
    start_date { Faker::Date.backward(days: 14) }
    due_date { Faker::Date.forward(days: 14) }
    status { :not_started }
    priority { :middle }
    details { Faker::Lorem.paragraph }
  end
end
