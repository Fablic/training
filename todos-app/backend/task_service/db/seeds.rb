# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

5.times do
  Task.create(
    user_id: 0,
    title: Faker::Lorem.sentence,
    description: Faker::Lorem.paragraph,
    priority: Faker::Number.between(from: 0, to: 5),
    status: Faker::Number.between(from: 0, to: 3), due_date: Faker::Date.forward(days: 10)
  )
end
