FactoryBot.define do
  factory :task, class: Task do
    name { 'Task Name' }
    desc { 'Description' }
    status { 0 }
    label { 'label' }
    priority { 1 }
    due_date { Faker::Time.forward(days: 1,  period: :evening) }
    user_id { 1 }

    trait :invalid do
      name { '' }
    end
  end
end
