FactoryBot.define do
  factory :user do
    name { Faker::Name }
    email { 'hoge@example.com'}
    password_digest { Faker::Lorem.word }
  end
end
