FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "Rails研修#{n}" }
    description { "テストデータをFactory Botで管理する" }
    expire_at { Time.current }

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

    trait :expire_tomorrow do
      expire_at { Time.current.tomorrow }
    end

    trait :expire_next_month do
      expire_at { Time.current + 1.month }
    end

  end
end
