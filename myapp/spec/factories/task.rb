FactoryGirl.define do
  factory :task do
    user
    sequence(:title) { |n| "test_title_#{n}" }
    sequence(:description) { |n| "test_description_#{n}" }
    sequence(:termination_at) { |n| Date.today + n }
    priority Task.priorities.key(0)
    status Task.statuses.key(0)
    sequence(:created_at) { |n| Date.today + n }

    trait :with_label do
      transient do
        label_count { 2 }
        labels { create_list(:label, label_count, name: 'sample_label01') }
      end

      after(:build) do |task, evaluator|
        task.labels << evaluator.labels
      end
    end

    trait :with_same_label do
      transient do
        labels { Label.first || create(:label, name: 'sample_label01') }
      end

      after(:build) do |task, evaluator|
        task.labels << evaluator.labels
      end
    end
  end
end
