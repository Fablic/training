# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    personal_id { 'MyUserID' }
    name { 'MyName' }
    pass { 'pass' }
  end
end
