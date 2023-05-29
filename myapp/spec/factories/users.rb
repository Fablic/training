FactoryBot.define do
  factory :user do
    name { Faker::Name }
    email { Faker::Internet.email}
    password { 'password' }
  end
end
