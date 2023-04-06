User.create!(
  [
    {
      email: 'test_kun@rakuten.com',
      name: 'テストくん',
      password: '12345678',
      role: 'admin'
    },
    {
      email: 'test_san@rakuten.com',
      name: 'テストさん',
      password: 'abcdefgh',
      role: 'ordinary'
    }
  ]
)

30.times do |n|
  Task.create!(
        title: "task_#{n+1}",
        expires_at: n.day.since,
        priority: Task::PRIORITY_LIST[n%3],
        status: Task::STATUS_LIST[n%3],
        description: "task_description_#{n+1}",
        user_id: [1, 2][n%2]
        )
end

30.times do |n|
  Label.create!(
        name: "label_#{n+1}"
        )
end

l = (1..30).to_a

30.times do |n|
  5.times do |m|
    TaskLabel.create!(
          task_id: n,
          label_id: l.sample 
          )
  end
end
