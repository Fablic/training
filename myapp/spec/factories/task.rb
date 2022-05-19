FactoryGirl.define do
  factory :task do
    user_id { FactoryGirl.create(:user).id }
    sequence(:title) { |n| "test_title_#{n}" }
    sequence(:description) { |n| "test_description_#{n}" }
    sequence(:termination_at) { |n| Date.today + n }
    priority Task.priorities.key(0)
    status Task.statuses.key(0)
    sequence(:created_at) { |n| Date.today + n }
  end
end
