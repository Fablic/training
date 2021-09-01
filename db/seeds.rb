# frozen_string_literal: true

AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?
User.create!(name: 'first user', email: 'first@example.com', password: 'password')

10.times do |n|
  Task.create!(
    name: "#{n + 1}つ目のタスク",
    description: "#{n + 1}日に\n何かをする",
    user: User.first,
  )
end
