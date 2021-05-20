FactoryBot.define do
  factory :task do
    name { '' }
    description { '' }
    priority { 'normal' }
    status { 'waiting' }
  end
end
