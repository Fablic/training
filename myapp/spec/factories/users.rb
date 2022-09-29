# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name) { |i| "USER名_#{i}" }
    sequence(:email) { |i| "Eメール_#{i}" }
    password_digest { SecureRandom.alphanumeric }
  end
end
