# タスク
100.times do |i|
	Task.create(
		title: "Rails研修step#{i}",
		description: '研修の説明',
		status: rand(0..2)
	)
end

# ユーザー
5.times do |i| 
	name = Faker::Name.name
	User.create(
		name: name,
		email: "rails#{i}@gmail.com",
		password: 'password'
	)
end