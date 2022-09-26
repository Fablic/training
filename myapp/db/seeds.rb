# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
Function.destroy_all

5.times do |i|
  # Create Users
  user = User.create!(name: "ユーザ#{i + 1}", password: "test#{i + 1}", email: "email#{i + 1}@example.com")
end

# Create Functions
Function.create!(id: Function::FUNC_ID_SYSTEM, name: 'タスク管理システム', status: Function.statuses[:started])
Function.create!(id: Function::FUNC_ID_CREATE, name: '作成機能', status: Function.statuses[:started])
Function.create!(id: Function::FUNC_ID_UPDATE, name: '編集機能', status: Function.statuses[:started])
Function.create!(id: Function::FUNC_ID_DELETE, name: '削除機能', status: Function.statuses[:started])

