FactoryBot.define do
  factory :label do
    sequence(:value){|n| "Label#{n}"}
    user
  end
end
