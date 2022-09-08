# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
Task.destroy_all
Label.destroy_all

5.times do |i|
  # Create Users
  user = User.create!(name: "ユーザ#{i + 1}", password_digest: "test#{i + 1}", email: "email#{i + 1}@example.com")

  # Create Tasks
  10.times do |j|
    task = Task.create!(
      title: "タスク#{i + 1}-#{j + 1}",
      content: "こちらはタスク#{i + 1}-#{j + 1}の内容です。",
      user_id: user.id,
      status: "#{(j % 3) + 1}",
    )

    # Create Labels
    (j % 6).times do |k|
      Label.create!(
        name: "ラベル#{i + 1}-#{j + 1}-#{k + 1}",
        task_id: task.id,
      )
    end
  end
end
