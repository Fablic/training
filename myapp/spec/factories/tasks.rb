FactoryBot.define do
  factory :task, class: Task do
#    sequence(:task_name) { |n| "task_name{n}" }
#    sequence(:description) { |n| "description{n}" }
    task_name { 'TEST task' }
    description { 'TEST desc' }
    priority { 1 }
    start_date = Date.parse("2021/01/01")
    end_date   = Date.parse("2021/12/31")
  end
end
