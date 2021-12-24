FactoryBot.define do
  factory :label do
    sequence(:name) { |n| "label-#{n}" }
  end
end
