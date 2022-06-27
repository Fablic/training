TASK_NUM = 20
USER_NUM = 5

USER_NUM.times do |i|
  name = Faker::Name.name
  user = User.create(
    name: name,
    email: "rails#{i}@gmail.com",
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
