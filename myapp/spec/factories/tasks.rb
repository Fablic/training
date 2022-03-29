# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { 'task_name' }
    description { 'task_description' }
  end
end
