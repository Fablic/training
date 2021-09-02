# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'Taro' }
    password { 'password' }
    password_confirmation { 'password' }
    sequence(:email, 'test_1@example.com')
  end
end
