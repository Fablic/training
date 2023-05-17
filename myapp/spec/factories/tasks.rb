require 'faker'

FactoryBot.define do
  factory :task do
    title { Faker::Lorem.word }
    content { Faker::Lorem.word }
    status  { 1 }
    deadline { Faker::Date.backward }
  end
end
