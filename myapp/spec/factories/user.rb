# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    id { 1 }
    name { 'test' }
    email { 'test@gmail.com' }
    password { 'password' }
  end
end
