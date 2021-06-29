FactoryBot.define do
  factory :task do
    association :user
     title { Faker::Alphanumeric.alphanumeric(number: 10) }
     description { Faker::Alphanumeric.alphanumeric(number: 10) }
     due_date { Faker::Time.forward }
  end
end
