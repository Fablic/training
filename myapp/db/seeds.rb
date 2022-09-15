# coding: utf-8

User.create(user_name: '草刈', password: 'kusakari', email: 'kusakari@example.com')
User.create(user_name: '中村', password: 'nakamura', email: 'nakamura@example.com')

Task.create(name: 'Step8', detail: 'Step8実施', status: 1, priority: 1, user_id: 1)
Task.create(name: 'Step9', detail: 'Step9実施', status: 1, priority: 1, user_id: 1)
Task.create(name: 'Step10', detail: 'Step10実施', status: 1, priority: 1, user_id: 2)

Label.create(label_name: 'Rails研修')
Label.create(label_name: 'プロダクト研修')
Label.create(label_name: 'その他')

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
