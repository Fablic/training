FactoryBot.define do
  sequence :labels_name do |n|
    "ごりら#{n}"
  end

  factory :label do
    name { generate :labels_name }

    association :user
  end
end
