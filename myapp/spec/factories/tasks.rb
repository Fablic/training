FactoryBot.define do
  factory :task, class: Task do
    sequence(:task_name) { |n| "Task_name#{n}" }
    sequence(:description) { |n| "Description#{n}" }
#    task_name { 'TEST task' }
#    description { 'TEST desc' }
     sequence(:priority) { |n| "#{n}" }
    start_date = Time.zone.yesterday.strftime('%Y/%m/%d %H:%M:$S')
    end_date   = Time.zone.today.strftime('%Y/%m/%d %H:%M:$S')
  end
end
