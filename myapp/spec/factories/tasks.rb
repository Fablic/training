FactoryBot.define do
    factory :task do
      name { 'タスク名１' }
      description { 'タスク名１を実施する' }
      status { 1 }
    end
  end
