FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "test_title#{n}" }
    content { 'test_content' }
    sequence(:created_at) { |n| Time.current + n }
  end
end
