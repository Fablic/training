FactoryBot.define do
  factory :user do
    username { Faker::Internet.unique.username }
    password_digest { Faker::Internet.password(min_length: 8) }
    role { :member }
  end
end
