# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Alphanumeric.alpha(number: 10) }
  end
end
