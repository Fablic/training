FactoryBot.define do
  factory :task, class: 'Task' do
    title    { 'title' }
    content  { 'content' }
    label    { 'label' }
    status   { 'not_started' }

    user
  end
end
