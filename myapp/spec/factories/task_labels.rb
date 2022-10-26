# frozen_string_literal: true

FactoryBot.define do
  factory :task_label do
    association :task, factory: :task, strategy: :build
    association :label, factory: :label, strategy: :build
  end
end
