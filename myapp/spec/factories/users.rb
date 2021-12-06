# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Lorem.characters(number: 32) }
    email { Faker::Internet.email }
    password { 'password' }
  end
end
