# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    sequence(:name, "test_task_1")
    sequence(:start_at, Date.new(2020, 3, 1))
    sequence(:due_date_at, Date.new(2020, 3, 2))
    sequence(:_at, Date.new(2020, 3, 2))
    description { 'description' }
    status { 'not_started' }
  end
end
