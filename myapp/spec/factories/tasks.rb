FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "test_title#{n}" }
    content { 'test_content' }
  end
end
