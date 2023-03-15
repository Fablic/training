FactoryBot.define do
  sequence :user_name do |n|
    "taro#{n}"
  end

  sequence :email do |n|
    "taro#{n}@hoge.hoge"
  end

  factory :user do
    name { generate :user_name }
    email { generate :email }
    password { 'password' }
  end
end
