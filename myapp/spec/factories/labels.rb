# frozen_string_literal: true

FactoryBot.define do
  factory :label do
    sequence(:name) { |i| "ラベル名_#{i}" }
  end
end
