FactoryBot.define do
  factory :task do
    name { 'task' }
    user
    description { 'This is a special task' }
    priority { 'normal' }
    status { 'waiting' }
  end
end
