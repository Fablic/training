FactoryBot.define do
  factory :user, class: User do
    sequence(:name)    { |n| "name#{n}" }
  end
end
