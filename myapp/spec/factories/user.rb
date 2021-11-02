# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: User do
    name     { Faker::Name.name }
    password { Faker::String.random }
    is_admin { Faker::Boolean.boolean }
  end
end
