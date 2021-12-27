FactoryBot.define do
  factory :user do
    email { "MyString" }
    username { "MyString" }
    role { 1 }
    password { "" }
  end
end
