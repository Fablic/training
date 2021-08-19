FactoryBot.define do
  factory :task do
    name { 'MyString' }
    description { 'Memo' }
    due_at { '2021-08-17 10:59:26' }
    priority { 1 }
    progress { 1 }
  end
end
