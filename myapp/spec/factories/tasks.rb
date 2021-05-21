FactoryBot.define do
  factory :task do
    name { 'task' }
    description { 'This is a special task' }
    priority { 'normal' }
    status { 'waiting' }
  end
end
