# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:uid) { |n| "User#{n}" }
    salt { '' }
    password_hash { '' }
  end
end
