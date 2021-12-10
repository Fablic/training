FactoryBot.define do
  factory :user do
    name { 'TestUser' }
    email { 'test-email@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
