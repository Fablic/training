FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "Task#{n}" }
    sequence(:description) { |n| "description #{n}\ndescription #{n}}" }
    sequence(:due_date) { |n| n.days.from_now }
  end
end
