# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { 'task_name' }
    description { 'task_description' }
    status { '未着手' }
  end
  factory :task2, class: 'Task' do
    name { 'task_name_2' }
    description { 'task_description_2' }
    status { '着手中' }
  end
  factory :task3, class: 'Task' do
    name { 'task_name_3' }
    description { 'task_description_3' }
    status { '完了' }
  end
end
