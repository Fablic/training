FactoryBot.define do
  factory :user do
    name { Faker::Name }
    email { Faker::Internet.email }
    password_digest { Faker::Lorem.word }
  end
end
