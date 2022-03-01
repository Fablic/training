FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "test #{n}" }
    sequence(:contents) { 'test' }
    sequence(:priority_id) { 1 }
    sequence(:status_id) { 1 }
    sequence(:board_id) { 1 }
    sequence(:due_date) { '2022/01/01 01:01:00' }
  end
end
