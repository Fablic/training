# frozen_string_literal: true

FactoryBot.define do
  sequence :task_seq do |i|
    "task_#{i}"
  end

  factory :task, class: Task do
    name { generate :task_seq }
    description { name.to_s }
    created_by { 1 }
    status { :pending }
    finished_at { rand(1..100).days.from_now }
  end
end

def task_with_labels(label_count: 5)
  FactoryBot.create(:task) do |task|
    FactoryBot.create_list(:label, label_count, tasks: [task])
  end
end
