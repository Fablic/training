TASK_NUM = 20
USER_NUM = 5

# Adminユーザー
admin_user = User.create!(
  name: 'admin_user',
  email: 'admin@example.com',
  password: 'password',
  role: 1,
)

TASK_NUM.times do |j|
  admin_user.tasks.create(
    title: "Admin-Task#{j}",
    description: 'Taskの説明',
    status: rand(0..2),
  )
end

USER_NUM.times do |i|
  name = Faker::Name.name
  user = User.create(
    name: name,
    email: "rails#{i}@example.com",
    password: 'password',
  )
  TASK_NUM.times do |j|
    user.tasks.create(
      title: "#{user.name}-Rails研修step#{j}",
      description: '研修の説明',
      status: rand(0..2),
    )
  end
end
