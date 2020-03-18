FactoryBot.define do

  factory :task1, class: Task do
    summary { 'task1' }
    description { 'this is 1st task' }
    priority { 1 }
    status { 1 }
    due { Date.today.end_of_month }
    association :user, factory: :user
  end
  factory :task2, class:Task do
    summary { 'task2' }
    description { 'this is 2nd task' }
    priority { 3 }
    status { 3 }
    due { Date.today.end_of_month }
    association :user, factory: :user
  end

  factory :task3, class: Task do
    summary { 'task3' }
    description { 'this is 3rd task' }
    priority { 5 }
    status { 5 }
    due { Date.today.end_of_month }
    association :user, factory: :user
  end
end
