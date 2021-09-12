FactoryBot.define do
  factory :task do
    name { 'task 1' }
    description { 'task 1 description' }
    priority { 0 } #low
  end
end
