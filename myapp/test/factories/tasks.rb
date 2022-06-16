FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "Rails研修#{n}" }
    description { "テストデータをFactory Botで管理する" }
    expire_at { "2022-06-13 12:00:00" }

    trait :no_title do
      title { nil }
    end

    trait :long_title do
      title { 'a' * 256 }
    end

    trait :created_yesterday do
      created_at { Time.current.yesterday }
    end

    trait :created_1week_ago do
      created_at { Time.current.ago(7.days) }
    end

  end
end
