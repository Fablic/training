FactoryBot.define do
  factory :board do
    sequence(:title) { |n| "TEST_BOARD#{n}" }
  end
end

