# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'MyString' }
    password { 'MyString' }
    password_confirmation { 'MyString' }
    sequence(:email, 'test_1@example.com')
  end
end
