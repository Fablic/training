FactoryBot.define do
  sequence :email do |i|
    "test#{i}@example.com"
  end

  factory :user do
    email { generate :email }
    first_name { 'hoge' }
    last_name { 'test' }
    password { 'hoge123' }
    role { 0 }
    invalid_flg { 0 }
  end
end
