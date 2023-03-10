User.create!(
  [
    {
      email: 'test_kun@rakuten.com',
      name: 'テストくん',
      encrypted_password: User.md5_converter('123')
    },
    {
      email: 'test_san@rakuten.com',
      name: 'テストさん',
      encrypted_password: User.md5_converter('abc')
    }
  ]
)
20.times do |n|
  Task.create!(
        title: "task_#{n+1}",
        expires_at: 1.week.since,
        priority: Task::PRIORITY_LIST[n%3],
        status: Task::STATUS_LIST[n%3],
        description: "task_description_#{n+1}",
        user_id: [1, 2].sample
        )
end
