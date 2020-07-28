# frozen_string_literal: true

FactoryBot.define do
  factory :app_user do
    name { 'user1' }
    password { 'pass' }
    start_date { Time.zone.now }
    suspended { false }
  end
end
