FactoryBot.define do
  factory :task, class: Task do
    sequence(:title) { |n| "test_title#{n}" }
    sequence(:description) { |n| "test_description#{n}" }
    sequence(:created_at, Date.today)
    sequence(:due_date, Date.today) 
    sequence(:user_id, 1) 
    status { 0 }
  end
end
