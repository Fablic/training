# frozen_string_literal: true

FactoryBot.define do
  factory :task1, class: Task do
    title { "test title 1" }
    description { "test description 1" }
    created_at { Time.new(2000, 1, 1, 0, 0, 0) }
    expiration_date { Time.new(2000, 2, 1, 0, 0, 0) }
    user_id { :user_id }
    status { "not_started" }
  end
  factory :task2, class: Task do
    title { "test title 2" }
    description { "test description 2" }
    created_at { Time.new(2000, 1, 2, 0, 0, 0) }
    expiration_date { Time.new(2000, 2, 2, 0, 0, 0) }
    user_id { :user_id }
    status { "in_progress" }
  end
  factory :task3, class: Task do
    title { "test title 3" }
    description { "test description 3" }
    created_at { Time.new(2000, 1, 3, 0, 0, 0) }
    expiration_date { Time.new(2000, 2, 3, 0, 0, 0) }
    user_id { :user_id }
    status { "completed" }
  end
  factory :task4, class: Task do
    title { "test title 4" }
    description { "test description 4" }
    created_at { Time.new(2000, 1, 4, 0, 0, 0) }
    expiration_date { Time.new(2000, 2, 4, 0, 0, 0) }
    user_id { :user_id }
  end
  factory :task5, class: Task do
    title { "test title 5" }
    description { "test description 5" }
    created_at { Time.new(2000, 1, 5, 0, 0, 0) }
    expiration_date { Time.new(2000, 2, 5, 0, 0, 0) }
    user_id { :user_id }
  end
  factory :task6, class: Task do
    title { "test title 6" }
    description { "test description 6" }
    created_at { Time.new(2000, 1, 6, 0, 0, 0) }
    expiration_date { Time.new(2000, 2, 6, 0, 0, 0) }
    user_id { :user_id }
  end
  factory :task7, class: Task do
    title { "test title 7" }
    description { "test description 7" }
    created_at { Time.new(2000, 1, 7, 0, 0, 0) }
    expiration_date { Time.new(2000, 2, 7, 0, 0, 0) }
    user_id { :user_id }
  end
  factory :task8, class: Task do
    title { "test title 8" }
    description { "test description 8" }
    created_at { Time.new(2000, 1, 8, 0, 0, 0) }
    expiration_date { Time.new(2000, 2, 8, 0, 0, 0) }
    user_id { :user_id }
  end
  # factory :task_empty_title, class: Task do
  #   title {""}
  #   user_id { :user_id }
  # end
  # factory :task_too_long_title, class: Task do
  #   title {"X" * 110}
  #   user_id { :user_id }
  # end
  factory :task_empty_description, class: Task do
    title { "X" }
    description { "" }
    user_id { :user_id }
  end
  # factory :task_too_long_description, class: Task do
  #   title {"X"}
  #   description {"Y"*30100}
  #   user_id { :user_id }
  # end
end
