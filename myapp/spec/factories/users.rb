# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: User do
    id { 999999 }
    login_id { 'login_id' }
    password { 'password' }
    name     { 'name' }
    is_admin { true }
  end
end
