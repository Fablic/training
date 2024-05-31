# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(name: "user 1", email: "user1@example.com", password: "123")
User.create(name: "user 2", email: "user2@example.com", password: "123")

Task.create(title: "title 1", description: "description 1", user_id: 1)
Task.create(title: "title 2", description: "description 2", user_id: 1)
Task.create(title: "title 3", description: "description 3", user_id: 1)

Task.create(title: "title 21", description: "description 21", user_id: 2)
Task.create(title: "title 22", description: "description 22", user_id: 2)
Task.create(title: "title 23", description: "description 23", user_id: 2)

Label.create(label: 'label 1')
Label.create(label: 'label 2')
Label.create(label: 'label 3')
Label.create(label: 'label 4')
