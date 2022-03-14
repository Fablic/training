FactoryBot.define do
  factory :task do
    user_id { 1 }
    sequence(:title) { |n| "テストタスク_#{n}" }
    sequence(:body) { |n| "テスト内容_#{n}" }
    deadline { Date.current.weeks_since(1) }
    priority { 2 }
    label_id { nil }
    status { 1 }
  end
end
