FactoryBot.define do
  sequence :task_name do |n|
    "task#{n}"
  end

  factory :task do
    association :user
    name { generate :task_name }
    status { 'unstarted' }
  end
end
