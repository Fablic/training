FactoryBot.define do
    factory :task do
      sequence(:title) { |n| "test_title#{n}" }
      content { 'testcontent' }
      priority { '1' }
      status { '1' }
      due_date { '2022-01-06 18:00:00 +0900' }
    end
  end