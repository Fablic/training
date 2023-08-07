FactoryBot.define do
  factory :user do
    id { 1 }
    first_name { 't'}
    username { 'test' }
    email { 'test@gmail.com' }
    password { 'password' }
    is_admin { true }
  end
end