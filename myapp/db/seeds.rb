# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

5.times do |i|
  user =  User.create( name: "seed #{i+1}", email: "seed#{i+1}@example.com", authority: 20, password: 'password' )
end

50.times do |i|
  Task.create( title: "seed #{i+1}", detail: "seed detail", priority: 10, status:10, due_date: "2021-10-31",user: User.first)
end
