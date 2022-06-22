TASK_NUM = 100
USER_NUM = 10

# タスク
TASK_NUM.times do |i|
	Task.create(
		title: "Rails研修step#{i}",
		description: '研修の説明',
		status: rand(0..2),
		user_id: i % USER_NUM
	)
end

# ユーザー
USER_NUM.times do |i| 
	name = Faker::Name.name
	User.create(
		name: name,
		email: "rails#{i}@gmail.com",
		password: 'password'
	)
end