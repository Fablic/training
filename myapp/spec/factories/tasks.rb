FactoryBot.define do
  factory :task do
    sequence(:name) { |i| "task_name_#{i}"}
    sequence(:description) { |i| "task_description_#{i}"}
    sequence(:created_at, Date.today)
    sequence(:updated_at, Date.today)
  end
end
