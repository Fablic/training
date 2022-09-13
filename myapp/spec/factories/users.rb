FactoryBot.define do
  factory :user, class: User do
    name              { 'name' }
    password          { 'password' }
    sequence(:email)  { |n| "test#{n}@example.com" }
  end
end
