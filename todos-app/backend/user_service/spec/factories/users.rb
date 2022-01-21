FactoryBot.define do
  factory :user do
    id { 1 }
    email { Faker::Internet.email }
    username { Faker::Internet.username }
    role { Faker::Number.between(from: 0, to: 1) }
    password { Faker::Internet.password }
  end
end
