FactoryBot.define do
  factory :status do
    sequence(:title) { |n| "STATUS #{n}" }
    sequence(:board_id) { 1 }
  end
end
