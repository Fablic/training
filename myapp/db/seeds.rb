# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Task、User 初期データ
10.times do |n|
    user = User.create!(name: "name#{n}")
    Task.create!(
      title: "#{n} title",
      description: "#{n} descriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescription",
      user_id: user[:id],
      status: '1',
      label: "#{n} label"
    )
end
  