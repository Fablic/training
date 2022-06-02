# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Creating normal user
User.create!(name: 'normal', email: 'normal@gmail.com' ,password: 'passwordNormal', password_confirmation: 'passwordNormal', admin_flg: 0)

# Creating admin user
User.create!(name: 'admin', email: 'admin@gmail.com' ,password: 'passwordAdmin', password_confirmation: 'passwordAdmin', admin_flg: 1)
