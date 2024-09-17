FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "JohnDoe#{n}" }
    password { 'dummyPassword123!?' }
  end
end
