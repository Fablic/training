FactoryBot.define do
    factory :label do
      name { Faker::Alphanumeric.alphanumeric(number: 5) }
    end
  end
