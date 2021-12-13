# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :task do
    title { Faker::Lorem.unique.characters(number: 255) }
    description { Faker::Lorem.unique.characters(number: 768) }
    status { Task.statuses.values.sample }
    priority { Task.priorities.values.sample }
    sequence(:expires_at) { |n| Faker::Time.between(from: DateTime.now + n, to: DateTime.now + n + 1) }
    sequence(:created_at) { |n| Faker::Time.between(from: DateTime.yesterday + n, to: DateTime.yesterday + n + 1) }
    association :user, factory: :user
  end
end
