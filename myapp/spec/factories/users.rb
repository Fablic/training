FactoryBot.define do
  sequence :name do |n|
    "taro#{n}"
  end

  sequence :email do |n|
    "taro#{n}@hoge.hoge"
  end

  factory :user do
    name { generate :name }
    email { generate :email }
    password { 'password' }
  end
end
