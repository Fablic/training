FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" }
    password { 'password' }
  end
end
