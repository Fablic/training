# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

label = Label.where(label: "SEED").first_or_create
5.times do |user_num|
  role = user_num == 1 ? 20 : User.roles.values.sample
  user = User.create( name: "seed user#{user_num}", email: "seed#{user_num}@example.com", role: role, password: 'password' )
  50.times do |i|
    Task.create( title: "seed #{i}", detail: "seed detail", priority: Task.prioritys.values.sample, status:Task.statuses.values.sample, due_date: Time.zone.now.tomorrow.strftime('%Y-%m-%d'), labels: [label], user: user)
  end  
end

