FactoryBot.define do
    factory :user, class: User do
      name              { 'name' }
      salt              { 'salt' }
      password          { 'password' }
      sequence(:email)  { 'sample0@example.com' }
    end
  end
