# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

5.times do
  User.create(
    username: Faker::Internet::username,
    email: Faker::Internet::email,
    role: Faker::Number.between(from: 0, to: 1),
    password: Faker::Internet::password
  )
end