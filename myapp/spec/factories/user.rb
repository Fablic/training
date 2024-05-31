# frozen_string_literal: true

FactoryBot.define do
  factory :user1, class: User do
    name { "user 1" }
    email { "user1@example.com" }
    password { "123" }
  end
  factory :user2, class: User do
    name { "user 2" }
    email { "user2@example.com" }
    password { "123" }
  end
  factory :user3, class: User do
    name { "user 3" }
    email { "user3@example.com" }
    password { "123" }
  end
end
