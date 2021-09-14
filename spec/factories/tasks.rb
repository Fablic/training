FactoryBot.define do
  factory :task, class: Task do
    name { 'task 1' }
    description { 'task 1 description' }
    priority { 0 } #low
    status { 0 } #todo
  end

  factory :other_task, class: Task do
    name { 'other task' }
    description { 'other task description' }
    priority { 0 } #low
    status { 2 } #done
  end
end
