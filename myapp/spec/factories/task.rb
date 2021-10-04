FactoryBot.define do
    factory :task, class: Task do
        sequence(:title) { |n| "test_title#{n}" }
        sequence(:description) { |n| "test_description#{n}" }
        sequence(:created_at) { |n| "2021-10-04 00:00:.00000#{n}"}
    end
end
