# frozen_string_literal: true

FactoryBot.define do
  factory :label do
    name { Faker::Lorem.characters(number: 16) }
  end
end
