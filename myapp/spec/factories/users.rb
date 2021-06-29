FactoryBot.define do
  factory :user, class: User do
    email { "email0@email.com" }
    password_digest { "MyString" }
    role { 1 }
    name { "MyString" }
  end
end
