FactoryBot.define do
  factory :label do
    user
    sequence(:name) { |n| "label#{n}" }
    color { '#eeeeee' }
  end
end
