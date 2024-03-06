FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "User#{n}" }
    password { "password" }
  end
end
