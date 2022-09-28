FactoryBot.define do
  factory :task, class: 'Task' do
    title { 'test title' }
    description { 'test description' }
    status   { 'not_started' }

    user

    trait :with_label do
      transient do
        label_name { 'label_name' }
      end

      after(:build) do | task, evaluator |
        task.labels << build(:label, name: evaluator.label_name)
      end
    end

    trait :with_labels do
      transient do
        label_name { 'label_name' }
      end

      after(:build) do | task, evaluator |
        5.times do |i|
          task.labels << build(:label, name: "#{evaluator.label_name}#{i + 1}")
        end
      end
    end
  end
end
