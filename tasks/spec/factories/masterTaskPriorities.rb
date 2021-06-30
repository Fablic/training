FactoryBot.define do
  factory :low, class: MasterTaskPriority do
    initialize_with do
      MasterTaskPriority.find_or_initialize_by(
        id: 1,
        priority: '低'
      )
    end
  end
  factory :middle, class: MasterTaskPriority do
    initialize_with do
      MasterTaskPriority.find_or_initialize_by(
        id: 2,
        priority: '中'
      )
    end
  end
  factory :high, class: MasterTaskPriority do
    initialize_with do
      MasterTaskPriority.find_or_initialize_by(
        id: 3,
        priority: '高'
      )
    end
  end
end
