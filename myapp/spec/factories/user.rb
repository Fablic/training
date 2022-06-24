# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    id { 1 }
    name { 'test' }
    email { 'test@gmail.email' }
    password { 'password' }
  end
end
