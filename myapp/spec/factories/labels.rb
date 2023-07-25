FactoryBot.define do
  factory :label do
    name { "MyString" }
    association :user
  end
end
