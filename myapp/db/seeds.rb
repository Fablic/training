# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

normal_user = User.create!(login_id: 'normal', password: 'password', password_confirmation: 'password', name: 'normal_user', is_admin: false)
normal_tasks = normal_user.tasks.create!(
  [
    { task_name: 'test_task1', description: 'DESCRIPTION1', status: 'todo', priority: 9999 },
    { task_name: 'test_task2', description: 'DESCRIPTION2', status: 'done', priority: 9999 },
  ],
)
normal_labels = Label.create!(
  [
    { name: 'normal_label1' },
    { name: 'normal_label2' },
  ],
)
normal_tasks.each do |tasks|
  normal_labels.each do |label|
    Labelling.create!(task_id: tasks.id, label_id: label.id)
  end
end

admin_user = User.create!(login_id: 'admin', password: 'password', password_confirmation: 'password', name: 'admin_user', is_admin: true)
admin_tasks = admin_user.tasks.create!(
  [
    { task_name: 'admin_test_task1', description: 'admin_DESCRIPTION1', status: 'todo', priority: 9999 },
    { task_name: 'admin_test_task2', description: 'admin_DESCRIPTION2', status: 'done', priority: 9999 },
  ],
)
admin_labels = Label.create!(
  [
    { name: 'admin_label1' },
    { name: 'admin_label2' },
  ],
)
admin_tasks.each do |tasks|
  admin_labels.each do |label|
    Labelling.create!(task_id: tasks.id, label_id: label.id)
  end
end
