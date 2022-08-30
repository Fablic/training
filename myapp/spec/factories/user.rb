FactoryBot.define do
  factory :user, class: User do
    name              { 'name' }
    salt              { 'salt' }
    password_digest   { User.hash('password', salt) }
    sequence(:email)  { |n| "email#{n}@example.com" }
  end
end
