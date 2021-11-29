FactoryBot.define do
  factory :task do
    name { |i| "task_name_#{i}" }
    description { |i| "task_description_#{i}" }
    deadline { Faker::Date.between(from: Date.today, to: 1.month.since) }
    created_at { Date.today }
    updated_at { Date.today }
  end
end
