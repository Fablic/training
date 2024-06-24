# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

labels = Label.create!([
                         { name: 'bug' },
                         { name: 'duplicate' },
                         { name: 'enhancement' },
                         { name: 'good first issue' },
                         { name: 'help wanted' },
                         { name: 'invalid' },
                         { name: 'question' },
                         { name: 'wontfix' }
                       ])

user1 = User.create!(username: 'User1', password: 'password1', role: :admin)
user2 = User.create!(username: 'User2', password: 'password2', role: :member)

Task.create!(title: 'Title1', user: user1, details: 'Details1', labels: labels[1, 2])
Task.create!(title: 'Title2', user: user2, details: 'Details2')
Task.create!(title: 'Title3', user: nil, details: 'Details3', labels:)
