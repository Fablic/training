# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(id: 1,
            name: 'admin',
            username: 'mvincent.yap@rakuten.com',
            pw: BCrypt::Password.create('test1234'),
            first_run: false,
            admin: true)

User.create(id: 2,
            name: 'mvincent',
            username: 'mvincent.yap@gmail.com',
            pw: BCrypt::Password.create('test1234'),
            first_run: false,
            admin: false)
FactoryBot.create_list(:generic_user, 20)

Label.create(id: 1,
             name: 'public',
             created_by: 1,
             color: '#e6e6e6')

Label.create(id: 2,
             name: 'private',
             created_by: 1,
             color: '#4dd2ff')
FactoryBot.create_list(:task, 49, created_by: 1) do |task, _i|
  task.status = rand(0..2)
  task.priority = rand(1..10)
  task.finished_at = rand(1..100).days.from_now.strftime('%Y-%m-%d')
  task.save!
end
