FactoryBot.define do
  factory :task, class: 'Task' do
    title    { 'title' }
    content  { 'content' }
    status   { 'not_started' }

    user
  end
end
