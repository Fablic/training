FactoryBot.define do
  factory :task do
    name { 'Task Name' }
    desc { 'Description' }
    status { 'status' }
    label { 'label' }
    priority { 'priority' }
    due_date { 'due_date' }

    trait :invalid do
      name { '' }
    end
  end
end
