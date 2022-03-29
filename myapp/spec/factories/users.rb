FactoryGirl.define do
  factory :user do
    user_name "test_name"
    sequence(:email){|n| "test#{n}@example.com"}
    password "Passw0rd"
  end
end
