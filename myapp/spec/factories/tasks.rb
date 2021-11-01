FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "TASK#{n}" }
    sequence(:detail) { |n| "DEATAIL#{n}" }
    priority { Task.prioritys[:low] }
    status { Task.statuses[:waiting] }
    sequence(:due_date) { |n| Time.current + 86_400 + (n * 600) }
    sequence(:created_at) { |n| Time.current + (n * 600) }
    user_id { 1 }
    labels { [Label.where(label: 'XXXX').first_or_create] }
  end
end
