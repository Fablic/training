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
