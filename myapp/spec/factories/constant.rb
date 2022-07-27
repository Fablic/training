# frozen_string_literal: true

FactoryBot.define do
  factory :constant do
    key { 'maintenance_mode' }
    value { 'true' }
  end
end
