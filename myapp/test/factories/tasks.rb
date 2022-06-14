FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "Rails研修#{n}" }
    description { "テストデータをFactory Botで管理する" }
    expire_at { "2022-06-13 12:00:00" }
  end
end
