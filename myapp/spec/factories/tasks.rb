FactoryBot.define do
  factory :task, class: Task do
<<<<<<< HEAD
    sequence(:task_name) { |n| "Task_name_#{n}" }
    sequence(:description) { |n| "description_#{n}" }
    sequence(:priority) { |n| "#{n}" }
    sequence(:start_date, Date.today + 1)
    sequence(:end_date, Date.today + 10)
    sequence(:created_at, Date.today)
=======
#    sequence(:task_name) { |n| "task_name{n}" }
#    sequence(:description) { |n| "description{n}" }
    task_name { 'task' }
    description { 'desc' }
    priority { 1 }
    start_date = Date.parse("2021/01/01")
    end_date   = Date.parse("2021/12/31")
>>>>>>> origin/ichinoseken
  end
end
