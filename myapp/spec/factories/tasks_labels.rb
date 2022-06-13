FactoryGirl.define do
  factory :tasks_label do
    association :task
    association :label
  end
end
