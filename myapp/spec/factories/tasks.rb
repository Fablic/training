require 'faker'

FactoryBot.define do
  factory :task do
    title { Faker::Lorem.word }
    content { Faker::Lorem.word }
  end
end
