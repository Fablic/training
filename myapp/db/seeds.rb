# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(
  [
    { name: 'admin', role: 1, email: 'admin@tm.com', password_digest: 'admin123', },
    { name: 'general', role: 0, email: 'general@tm.com', password_digest: 'general123', }
  ])