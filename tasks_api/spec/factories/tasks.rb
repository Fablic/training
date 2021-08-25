FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "Task#{n}" }
    sequence(:description) { |n| "description #{n}\ndescription #{n}}" }
    sequence(:due_date) { |n| n.days.from_now }
    user

    trait :with_labels do
      after(:build) do |task|
        build_list(:label, 2, user: task.user).map { |l| task.labels << l }
      end
    end
  end
end
