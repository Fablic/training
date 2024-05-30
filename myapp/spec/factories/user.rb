# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { "user 1" }
    email { "user1@example.com" }
    password { "123" }
  end
end
