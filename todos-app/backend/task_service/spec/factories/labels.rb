FactoryBot.define do
  factory :label do
    user_id { 1 }
    name { Faker::Color.color_name }
  end
end
