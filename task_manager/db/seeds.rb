# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(name: "root",
  email: "root@railstutorial.org",
  password: "password",
  password_confirmation: "password",
  is_admin: true)

5.times do
  task = Task.create!(
    name: Faker::Hobby.activity,
    description: "memo",
    due_at: Faker::Date.between(from: Time.current + 1.day, to: Time.current + 1.year ),
    priority: rand(3),
    progress: rand(3),
    user_id: User.last.id,
  )
end
