FactoryBot.define do
  factory :task do
    title { "Rails研修" }
    description { "テストデータをFactory Botで管理する" }
    expire_at { "2022-06-13 12:00:00" }
  end

  # タイトルがnil
  trait :no_title do
    title { nil }
  end
end
