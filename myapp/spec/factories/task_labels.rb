# frozen_string_literal: true

FactoryBot.define do
  factory :task_label do
    association :task
    association :label
  end
end
