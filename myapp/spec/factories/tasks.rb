FactoryBot.define do
  factory :task do
    name { |i| "task_name_#{i}" }
    description { |i| "task_description_#{i}" }
    deadline { 1.hour.since }
    created_at { Date.today }
    updated_at { Date.today }
  end
end
