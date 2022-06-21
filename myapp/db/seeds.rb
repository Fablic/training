
100.times do |i|
	Task.create(
		title: "Rails研修step#{i}",
		description: '研修の説明',
		status: rand(0..2)
	)
end