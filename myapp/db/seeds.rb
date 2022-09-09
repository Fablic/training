# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Task.destroy_all
User.destroy_all

10.times do |i|
  user = User.create!(name: "ユーザ#{i + 1}", password: "test#{i + 1}", email: "email#{i + 1}@example.com")
  Task.create!(
    title: "タスク#{i + 1}",
    content: "こちらはタスク#{i + 1}の内容です。テストテストテストテストテストテストテスト",
    user_id: user.id,
    status: '1',
    label: "ラベル#{i + 1}",
  )
end
