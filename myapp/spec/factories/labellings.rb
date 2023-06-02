FactoryBot.define do
  factory :labelling do
    association :task
    association :label
  end
end
