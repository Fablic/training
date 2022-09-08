FactoryBot.define do
  factory :user, class: User do
    name              { 'name' }
    password_digest   { 'password' }
    sequence(:email)  { |n| "email#{n}@example.com" }
  end
end
