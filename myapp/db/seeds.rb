# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
Label.destroy_all
SystemMaintenance.destroy_all

# User
10.times do |n|
  User.create!(name: "ユーザ#{n + 1}", password: "test#{n + 1}", email: "email#{n + 1}@example.com")
end

# Label
5.times do |n|
  Label.create!(name: "ラベル#{n + 1}")
end

# SystemMaintenance
SystemMaintenance.create!(key: SystemMaintenance::KEY_TASK_MANAGEMENT, maintenance_flg: false)
