# frozen_string_literal: true

FactoryBot.define do
  factory :label do
    trait :labels1 do
      name { 'MyLabelName1' }
    end
    trait :labels2 do
      name { 'MyLabelName2' }
    end
  end
end
