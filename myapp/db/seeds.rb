# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
puts 'Seed starting...'

user = FactoryBot.create(:user)
[*1..5].each do |n|
  t = Task.create!(title: "Task #{n}", description: 'some description', due_date: n.days.from_now, user: user)
end

puts 'Seed finished'
