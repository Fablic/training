FactoryGirl.define do
    factory :task do
        user_id 0
        sequence(:title) { |n| "test_title_#{n}" }
        sequence(:description) { |n| "test_description_#{n}" }
        termination_at '2022-01-01 00:00:00'
        priority 0
        status 0
    end
  end
