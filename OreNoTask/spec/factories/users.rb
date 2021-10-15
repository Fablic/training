FactoryBot.define do
  factory :user do
    name { "MyString" }
    password { "MyString" }
    privilege { 1 }
    deleted { 1 }
  end
end
