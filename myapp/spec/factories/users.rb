FactoryBot.define do
  factory :user do
    name { 'test_name' }
    email { "one#{rand(100_000)}@example.com" }
    role { :member }
    password { 'password' }
  end
end
