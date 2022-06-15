FactoryBot.define do
  factory :label, class: Label do
    sequence(:name) { |n| "test_label#{n}" }
    sequence(:user_id, 1) 
  end
end
