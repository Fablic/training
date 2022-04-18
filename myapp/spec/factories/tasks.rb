# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { 'task_name' }
    description { 'task_description' }
    status { 'not_started' }
    association :user
  end
  factory :task2, class: 'Task' do
    name { 'task_name_2' }
    description { 'task_description_2' }
    status { 'in_progress' }
  end
  factory :task3, class: 'Task' do
    name { 'task_name_3' }
    description { 'task_description_3' }
    status { 'done' }
  end
end
