FactoryBot.define do
  factory :user do
    user_name { 'testUser' }
    password { 'testPassword' }
    email { 'testUser@example.com' }
  end
end
