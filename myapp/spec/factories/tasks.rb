FactoryBot.define do
  factory :task, class: 'Task' do
    title { 'test title' }
    description { 'test description' }
    status   { 'not_started' }

    user
  end
end
