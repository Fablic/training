FactoryBot.define do
  factory :task do
    association :user
    name { 'sample_task' }
    status { 'unstarted' }
  end
end
