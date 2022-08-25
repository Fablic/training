FactoryBot.define do
  factory :task do
    title { 'test title' }
    description { 'test description' }
    status { 0 }
    label { '1' }
  end
end
