# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user1 = User.create!(username: 'User1', password_digest: 'password1', role: :admin)
user2 = User.create!(username: 'User2', password_digest: 'password2', role: :member)

Task.create!(title: 'Title1', user_id: user1.id, details: 'Details1')
Task.create!(title: 'Title2', user_id: user2.id, details: 'Details2')
Task.create!(title: 'Title3', user_id: nil, details: 'Details3')
