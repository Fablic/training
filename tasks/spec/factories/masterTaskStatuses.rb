FactoryBot.define do
    factory :notStarted, class: MasterTaskStatus do
        initialize_with do
            MasterTaskStatus.find_or_initialize_by(
                id: 1,
                status: '未着手')
        end
    end
    factory :started, class: MasterTaskStatus do
        initialize_with do
            MasterTaskStatus.find_or_initialize_by(
                id: 2,
                status: '着手')
        end
    end
    factory :finished, class: MasterTaskStatus do
        initialize_with do
            MasterTaskStatus.find_or_initialize_by(
                id: 3,
                status: '完了')
        end
    end
  end