# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(
  name: 'てすたま',
  email: 'testama@example.com',
  password: 'password',
)
Label.create!(name: 'Label1')
Label.create!(name: 'Label2')
label1 = Label.create!(name: 'Label3')
label2 = Label.create!(name: 'Label4')

5.times do
  Task.create!(
    user_id: User.last.id,
    title: Faker::Hobby.activity,
    description: 'memo',
    status: Task.statuses.values.sample,
    priority: Task.priorities.values.sample,
    expires_at: Faker::Date.between(from: Time.current + 1.day, to: Time.current + 1.year),
  )
end

task1 = Task.find(1)
task2 = Task.find(2)

task1.labels << label1
task2.labels << label1
task2.labels << label2
