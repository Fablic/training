FactoryBot.define do
  factory :task do
    name { |i| "task_name_#{i}" }
    description { 'description' }
    deadline_at { 1.hour.since }
    status { 'not_started' }
    created_at { Date.today }
    updated_at { Date.today }
    user
  end
end
