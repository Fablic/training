FactoryBot.define do
  factory :user, class: User do
    name { 'test' }
    email { 'test@example.com' }
    password { 'password' }
  end
end
