FactoryBot.define do
  factory :task do
    user_id { 1 }
    sequence(:title) { |n| "test_title#{n}" }
    content { 'test_content' }
    sequence(:deadline) { |n| Time.current.next_month - n.days }
    sequence(:created_at) { |n| Time.current + n.days }
  end
end
