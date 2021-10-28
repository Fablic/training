FactoryBot.define do
  factory :user do
    name { 'test_name' }
    email { 'one@example.com' }
    role { 20 }
    password { 'password' }
  end
end
