# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create([
  { username: 'admin', email: "admin@example.com", password_digest: "$2a$08$QwaU8tAaIYMIvzoBg1rG/.D5gCyuQD7Jd30b.R.3EP1PuMzfTbKbi", role: :admin },
  { username: 'normal', email: "normal@example.com", password_digest: "$2a$08$QwaU8tAaIYMIvzoBg1rG/.D5gCyuQD7Jd30b.R.3EP1PuMzfTbKbi", role: :normal }
])
