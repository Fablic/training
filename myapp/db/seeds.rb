User.create!(
  [
    {
      name: 'useradmin',
      password: 'passwordadmin',
      role: :admin,
    },
    {
      name: 'user1',
      password: 'password1',
    },
    {
      name: 'user2',
      password: 'password2',
    }
  ]
)

User.all.each do |user|
  user.tasks.create!(
    title: 'タイトル',
    content: 'テキストテキストテキストテキスト'
  )
end
