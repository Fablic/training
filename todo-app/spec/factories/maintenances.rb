# frozen_string_literal: true

FactoryBot.define do
  factory :maintenance do
    reason { 'パッチ適用' }
    start_datetime { Time.zone.yesterday }
    end_datetime { Time.zone.tomorrow }
  end
end
