FactoryGirl.define do
  factory :task do
    user_id 0
    sequence(:title) { |n| "test_title_#{n}" }
    sequence(:description) { |n| "test_description_#{n}" }
    termination_at Date.today + 1
    priority Task.priorities.key(0)
    status Task.statuses.key(0)
  end
end
