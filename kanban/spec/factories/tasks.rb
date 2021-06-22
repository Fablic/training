FactoryBot.define do
  factory :task do
    name { 'タスク名' }
    description { '詳しい説明' }
    status { 'todo' }
    user_id { user.id }

    trait :invalid do
      name { '' }
    end
  end
end
