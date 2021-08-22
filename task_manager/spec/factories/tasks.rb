# frozen_string_literal: true

FactoryBot.define do
  factory :new_task, class: Task do
    name { 'MyString' }
    description { 'Memo' }
    due_at { '2021-08-17 10:59:26' }
    created_at { '2021-08-02 10:59:26' }
    priority { 1 }
    progress { 1 }
  end

  factory :old_task, class: Task do
    name { 'MyString' }
    description { 'Memo' }
    due_at { '2021-08-17 10:59:26' }
    created_at { '2019-09-02 10:59:26' }
    priority { 1 }
    progress { 1 }
  end
end
