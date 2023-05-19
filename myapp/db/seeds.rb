USER_NUM = 3
TASK_NUM = 3

USER_NUM.times do |i|
  name = Faker::Name.name
  user = User.create!(
    name: name,
    email: "test#{i}@gmail.com",
    password_digest: 'password',
  )
  TASK_NUM.times do |j|
    deadline = Faker::Date.backward
    content = Faker::Lorem.word
    user.tasks.create(
      title: "#{user.name}-test#{j}",
      content: content,
      status: rand(0..2),
      deadline: deadline,
    )
  end
end
