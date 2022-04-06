FactoryBot.define do
    factory :task do
      user_id { 1 }
      title { "test title" }
      body { "test body" }
      status { 1 }
      urgency { 3 }
      importance { 3 }
      priority_point { 90 }
      deadline { "2022-04-21" }
    end
  end
