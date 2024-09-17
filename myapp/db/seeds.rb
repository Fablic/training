# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create(id: 1, name: "admin", password: "Dummy123!?", role: 1)
User.create(id: 2,name: "sunao", password: "Dummy123!?", role: 2)
User.create(id: 3,name: "user1", password: "Dummy123!?", role: 0)
User.create(id: 4,name: "user2", password: "Dummy123!?", role: 0)
User.create(id: 5,name: "user3", password: "Dummy123!?", role: 0)

Task.create(title: "title 1", description: "desc 1", status: 1, user_id: 1)
Task.create(title: "title 2", description: "desc 2", user_id: 1)

Task.create(title: "タイトル 1", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", user_id: 2)
Task.create(title: "title 2", description: "", user_id: 2)
Task.create(title: "title 3", description: "タスクの詳細", due_date_at: '2024-12-31', user_id: 2)

Task.create(title: "some lo o o o o o o o o o o ong title", description: "desc 1", due_date_at: '2024-12-31', user_id: 4)
Task.create(title: "t", description: "", due_date_at: '2024-09-30', status: 2, user_id: 4)

Task.create(title: "title 1", description: "desc 1", status: 2, user_id: 5)
