FactoryBot.define do
  factory :task do
    name { 'Task Name' }
    desc { 'Description' }

    trait :invalid do
      name { '' }
    end
  end
end
