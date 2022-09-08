FactoryBot.define do
  factory :task do
    title { 'test title' }
    description { 'test description' }
    status   { 'not_started' }
    label { '1' }
  end
end
