# frozen_string_literal: true

FactoryBot.define do
  factory :admin, class: User do
    name { "admin" }
    email { "admin@example.com" }
    password { "123" }
    role { "admin" }
  end
  factory :user1, class: User do
    name { "user 1" }
    email { "user1@example.com" }
    password { "123" }
    role { "general" }
  end
  factory :user2, class: User do
    name { "user 2" }
    email { "user2@example.com" }
    password { "123" }
    role { "general" }
  end
  factory :user3, class: User do
    name { "user 3" }
    email { "user3@example.com" }
    password { "123" }
    role { "general" }
  end
end
