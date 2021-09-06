# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'Taro' }
    password { 'password' }
    password_confirmation { 'password' }
    sequence(:email, 'test_1@example.com')
  end

  factory :admin_user , class: User do
    name { 'admin' }
    password { 'password' }
    password_confirmation { 'password' }
    is_admin { true }
    sequence(:email, 'admin_1@example.com')
  end
end
