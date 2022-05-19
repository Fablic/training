FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password 'password'
  end
end
