FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "TASK#{n}" }
    sequence(:detail) { |n| "DEATAIL#{n}" }
    priority { Task.prioritys[:low] }
    status { Task.statuses[:waiting] }
    due_date { Time.zone.now.tomorrow }
    sequence(:created_at) { |n| Time.current + (n * 60) }
  end
end
