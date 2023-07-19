FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User#{n}" }
    password { "password" }
    description { "user description" }
    role { 0 }
  end
end
