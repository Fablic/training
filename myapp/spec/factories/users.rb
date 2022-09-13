FactoryBot.define do
  factory :user do
    name { 'テストユーザ' }
    email { 'test@example.com' }
    password { 'password' }
  end
end
