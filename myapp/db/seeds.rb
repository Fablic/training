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
      password: 'abcdefgh'
      role: 'ordinary'
    }
  ]
)
30.times do |n|
  Task.create!(
    title: "task_#{n + 1}",
    expires_at: n.day.since,
    priority: Task::PRIORITY_LIST[n % 3],
    status: Task::STATUS_LIST[n % 3],
    description: "task_description_#{n + 1}",
    user_id: [1, 2].sample
  )
end
