# frozen_string_literal: true

FactoryBot.define do
  factory :task, class: Task do
    sequence(:task_name) { |n| "Task_name_#{n}" }
    sequence(:description) { |n| "description_#{n}" }
    sequence(:priority) { |n| "#{n}" }
    sequence(:label) { |n| "label_#{n}" }
    status { 'done' }
    sequence(:start_date, Date.today + 1)
    sequence(:end_date, Date.today + 10)
    sequence(:created_at, Date.today)
    user_id { 999999 }
  end
end
