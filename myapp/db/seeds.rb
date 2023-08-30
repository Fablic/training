# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(first_name: 'test', last_name: 'admin', email: 'admin@example.com', password: 'hoge', is_admin: true, username: 'admin')
User.create!(first_name: 'test', last_name: 'user', email: 'user@example.com', password: 'hoge', is_admin: false, username: 'user')
