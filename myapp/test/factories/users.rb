# frozen_string_literal: true

FactoryBot.define do
  sequence :username_seq do |i|
    "user_#{i}"
  end

  factory :admin, class: User do
    name { 'admin' }
    username { 'mvincent' }
    password { 'test123' }
    password_confirmation { 'test123' }
    admin { true }
  end

  factory :non_admin, class: User do
    name { 'nonadmin' }
    username { 'nonadmin' }
    password { 'test123' }
    password_confirmation { 'test123' }
    admin { false }
  end

  factory :generic_user, class: User do
    name {  generate :username_seq }
    username { name.to_s }
    password { 'test123' }
    password_confirmation { 'test123' }
    admin { false }
  end
end
