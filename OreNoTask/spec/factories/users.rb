# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name, 'test_user_1')
    password { 'rakuten' }
    privilege { :user }
  end
end
