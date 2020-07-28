# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { 'タスク名' }
    status { 0 }
    due_date { Time.current.tomorrow }
  end
end
