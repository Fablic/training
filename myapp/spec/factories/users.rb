FactoryBot.define do
  factory :user do
    # id { 1 }
    sequence(:name) { |n| "JohnDoe#{n}" }
    password { 'dummyPassword123!?' }
  end
end
