# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# coding: utf-8
# User.create!(name: 'テスト太郎', email: 'test@test.com', password_digest: '111111')
User.create!(
  email: 'test3@example.com',
  password: '111111',
  name: 'テスト太郎'
)
