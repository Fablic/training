FactoryBot.define do
  factory :label do
    user
    sequence(:name) { |n| "ラベル#{n}" }
  end
end
