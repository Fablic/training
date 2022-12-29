# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name     { 'test' }
    email    { 'test@test.com' }
    password { 'password' }
    password_confirmation { 'password' }
    role { 1 }
  end
end
