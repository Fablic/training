FactoryBot.define do
  factory :task, class: 'Task' do
    title    { 'title' }
    content  { 'content' }
    user_id  { 1 }
    label    { 'label' }
    status   { 'not_started' }
  end
end
