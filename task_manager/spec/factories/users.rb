FactoryBot.define do
  factory :user do
    name { "MyString" }
    password { "MyString" }
    password_confirmation { "MyString" }
    sequence :email do |n|
      "test#{n}@example.com"
    end
  end
end
