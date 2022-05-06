FactoryGirl.define do
    factory :task do
        user_id 0
        title "test_title_01"
        description "test_description_01"
        termination_at '2022-01-01 00:00:00'
        priority 0
        status 0
    end
  end
  