FactoryBot.define do
  factory :task do
    title { 'test title' }
    description { 'test description' }
    status { Task.statuses[:not_started] }

    user
  end
end
