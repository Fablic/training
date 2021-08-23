FactoryBot.define do
  factory :user do
    sequence(:uid){|n|"User#{n}"}
    sequence(:salt){|n|n}
    sequence(:password_hash){|n|n}
  end
end
