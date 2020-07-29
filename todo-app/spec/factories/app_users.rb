# frozen_string_literal: true

FactoryBot.define do
  factory :app_user do
    name { 'user1' }
    password { 'pass' }
    start_date { Time.zone.now }
    suspended { false }
  end

  factory :admin_user, parent: :app_user do
    name { 'admin' }
    password { 'pass' }
    start_date { Time.zone.now }
    suspended { false }
    admin { true }
  end
end
