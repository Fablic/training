FactoryBot.define do
  factory :task, class: 'Task' do
    title    { 'title' }
    content  { 'content' }
    label    { 'label' }
    status   { 'not_started' }
    user_id  { FactoryBot.create(:user).id }
  end
end
