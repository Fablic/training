FactoryBot.define do
  factory :priority do
    sequence(:title) { |n| "PRIORITY #{n}" }
    sequence(:board_id) { 1 }
  end
end
