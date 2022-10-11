# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name) { |i| "USER名_#{i}" }
    sequence(:email) { |i| "Eメール_#{i}" }
    role { %w[ordinary admin].sample }
    password { 'password' }
  end
end
