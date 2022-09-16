# frozen_string_literal: true

FactoryBot.define do
    factory :label do
      trait :label_1 do
        name { 'MyLabelName1' }
      end
      trait :label_2 do
        name { 'MyLabelName2' }
      end
    end
  end
