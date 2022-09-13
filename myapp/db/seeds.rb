# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Task、User 初期データ
10.times do |n|
  user = User.create!(name: "ユーザ#{n + 1}", password: "test#{n + 1}", email: "email#{n + 1}@example.com")
end
