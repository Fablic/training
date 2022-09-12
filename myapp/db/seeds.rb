# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
10.times do |i|
    password = 'password'
    salt = User.create_salt
    password_digest = User.hash(password, salt)
    user = User.create!(name: "テストユーザ#{i}", email: "sample#{i}@example.com", password: 'password', password_confirmation: 'password')
    Task.create!(
      title: "タスク#{i}",
      description: "こちらはタスク#{i}の内容です。",
      user_id: user.id,
      status: '0',
      label: "ラベル#{i}"
    )
end
