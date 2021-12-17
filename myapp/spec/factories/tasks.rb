FactoryBot.define do
  factory :task do
    name { 'task_name' }
    description { 'description' }
    deadline_at { 1.hour.since }
    status { 'not_started' }
    created_at { Date.today }
    updated_at { Date.today }
    user
  end
end
