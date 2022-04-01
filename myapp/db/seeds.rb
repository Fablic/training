# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(user_name: 'hoge', email: 'aaa@example.co.jp', password: 'password')
User.create(user_name: '太郎', email: 'bbb@example.co.jp', password: '1234567')

5.times do |i|
  Label.create!(label_name: "sample#{i + 1}")
end
