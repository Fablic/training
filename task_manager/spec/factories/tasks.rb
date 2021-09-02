# frozen_string_literal: true

FactoryBot.define do
  factory :task, class: Task do
    name { 'a_task' }
    description { 'Memo' }
    due_at { Time.current + 2.days }
    created_at { '2019-09-02 10:59:26' }
    priority { 1 }
    progress { 1 }
    # user { build(:user) }
    association :user, factory: :user
  end

  factory :new_task, class: Task do
    name { 'b_task' }
    description { 'Memo' }
    due_at { Time.current + 10.days }
    created_at { '2021-08-02 10:59:26' }
    priority { 1 }
    progress { 0 }
    # association :user, factory: :user
  end
end
