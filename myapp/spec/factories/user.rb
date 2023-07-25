FactoryBot.define do
  factory :user do
    id { 1 }
    username { 'test' }
    email { 'test@gmail.com' }
    password_hash { 'password' }
  end
end