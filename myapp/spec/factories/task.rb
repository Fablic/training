# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :task do
    title { Faker::Lorem.characters(number: 20) }
    description { Faker::Lorem.characters(number: 500) }
    status { Task.statuses.values.sample }
    priority { Task.priorities.values.sample }
    expires_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
  end
end
