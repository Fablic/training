# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Normal User related
normal_user = User.create!(name: 'normal', password: 'passwordNormal', password_confirmation: 'passwordNormal', is_admin: false)
normal_user.tasks.create!(
  [
    { title: 'normal_hoge', description: 'normal_desc', due_date: '2021-02-01 00:00:00' },
    { title: 'normal_fuga', description: 'normal_desc', due_date: '2021-02-02 00:00:00' },
    { title: 'normal_hofu', description: 'normal_desc', due_date: '2021-02-03 00:00:00' },
    { title: 'normal_fuho', description: 'normal_desc', due_date: '2021-02-04 00:00:00' },
  ],
)

# Admin User related
admin_user = User.create!(name: 'admin', password: 'passwordAdmin', password_confirmation: 'passwordAdmin', is_admin: true)
admin_user.tasks.create!(
  [
    { title: 'admin_hoge', description: 'admin_desc', due_date: '2021-02-01 00:00:00' },
    { title: 'admin_fuga', description: 'admin_desc', due_date: '2021-02-02 00:00:00' },
    { title: 'admin_hofu', description: 'admin_desc', due_date: '2021-02-03 00:00:00' },
    { title: 'admin_fuho', description: 'admin_desc', due_date: '2021-02-04 00:00:00' },
  ],
)
