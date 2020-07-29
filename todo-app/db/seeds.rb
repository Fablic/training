# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

UNAMES = %w[taro hanako test].freeze

users = []

users << AppUser.create(name: 'admin', password: 'pass', start_date: Time.zone.yesterday, suspended: false, admin: true)

UNAMES.each do |uname|
  users << AppUser.create(name: uname, password: 'pass', start_date: Time.zone.yesterday, suspended: false)
end

TASKS = %w[掃除 洗濯 買い物 読書 勉強 散歩 ジム 食事].freeze

(1..3).to_a.each do |num|
  TASKS.each do |task|
    user = users.sample
    Task.create(name: task + '  ' + num.to_s, status: rand(0..2), due_date: Time.zone.now + 1, app_user: user)
  end
end
