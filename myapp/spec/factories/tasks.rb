FactoryBot.define do
  factory :task do
    title { 'test title' }
    description { 'test description' }
    status { Task.statuses[:not_started] }
    label { '1' }
    user_id  { 1 }
  end
end
