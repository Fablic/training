FactoryBot.define do
  factory :task do
    title { 'test title' }
    description { 'test description' }
    status { Task.statuses[:not_started] }

    user

    trait :with_label do
      transient do
        label_name { 'label_name' }
      end

      after(:build) do | task, evaluator |
        task.labels << build(:label, name: evaluator.label_name)
      end
    end
  end
end
