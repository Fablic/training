FactoryBot.define do
    factory :task, class: Task do
        sequence(:title) { |n| "test_title#{n}" }
        description { 'spec_description' }
    end
end
