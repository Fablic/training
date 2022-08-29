# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

10.times do |i|
  password = "test#{i + 1}"
  salt = User.create_salt
  puts salt
  password_digest = User.create_password(password, salt)
  puts password_digest
  user = User.create!(name: "ユーザ#{i + 1}", password_digest: password_digest, salt: salt)
  Task.create!(
    title: "タスク#{i + 1}",
    content: "こちらはタスク#{i + 1}の内容です。テストテストテストテストテストテストテスト",
    user_id: user.id,
    status: '1',
    label: "ラベル#{i + 1}"
  )
end
