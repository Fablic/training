# frozen_string_literal: true

User.create!(name: 'first user', email: 'first@example.com', password: 'password')

10.times do |n|
  Task.create!(
    name: "#{n + 1}つ目のタスク",
    description: "#{n + 1}日に\n何かをする",
    user: User.first,
  )
end
