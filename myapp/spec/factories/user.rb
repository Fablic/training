FactoryBot.define do
    factory :user, class: User do
      name              { 'name' }
      salt              { 'salt' }
      password_digest   { 'password' }
      sequence(:email)  { 'sample12345@example.com' }
    end
  end
