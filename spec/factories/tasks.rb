FactoryBot.define do
  factory :task, class: Task do
    association :user, factory: :user
    name { 'task 1' }
    description { 'task 1 description' }
    priority { 0 } #low
    status { 0 } #todo
  end

  factory :task_2, class: Task do
    association :user, factory: :user
    name { 'task 2' }
    description { 'task 2 description' }
    priority { 0 } #low
    status { 2 } #done
  end
end
