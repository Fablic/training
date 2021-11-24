# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
users = [
  User.new(login_id: 'normal', password: 'password', password_confirmation: 'password', name: 'normal_user', is_admin: false),
  User.new(login_id: 'admin', password: 'password', password_confirmation: 'password', name: 'admin_user', is_admin: true),
]
labels_list = %w[開発 テスト]

users.each do |user|
  user.save
  10.times do |n|
    user.tasks.create(task_name: "test_task#{n}_#{user.name}", description: "DESCRIPTION#{n}_#{user.name}", status: 'todo', priority: 9999)
  end
  labels_list.each do |label|
    user.labels.create(name: label)
  end
end

# normal_user = User.create!(login_id: 'normal', password: 'password', password_confirmation: 'password', name: 'normal_user', is_admin: false)
# normal_user.tasks.create!(
#   [
#     { task_name: 'test_task1', description: 'DESCRIPTION1', status: 'todo', priority: 9999 },
#     { task_name: 'test_task2', description: 'DESCRIPTION2', status: 'done', priority: 9999 },
#   ],
# )
# normal_user.labels.create!(
#   [
#     { name: 'normal_label1' },
#     { name: 'normal_label2' },
#   ],
# )

# admin_user = User.create!(login_id: 'admin', password: 'password', password_confirmation: 'password', name: 'admin_user', is_admin: true)
# admin_user.tasks.create!(
#   [
#     { task_name: 'admin_test_task1', description: 'admin_DESCRIPTION1', status: 'todo', priority: 9999 },
#     { task_name: 'admin_test_task2', description: 'admin_DESCRIPTION2', status: 'done', priority: 9999 },
#   ],
# )
# admin_user.labels.create!(
#   [
#     { name: 'admin_label1' },
#     { name: 'admin_label2' },
#   ],
# )
