# user
users = [
  User.new(name: '橋本', mail_address: 'yu.a.hashimoto@rakuten.com'),
  User.new(name: '管理者', mail_address: 'yu.a.hashimoto-1@rakuten.com'),
  User.new(name: 'テストユーザー', mail_address: 'yu.a.hashimoto-2@rakuten.com')
]
labels = %w[手続き 実働 その他]

users.each do |user|
  user.assign_attributes(role_id: 1, password: 'test', password_confirmation: 'test')
  user.save
  10.times do |n|
    user.tasks.create(name: "サンプル#{n} #{user.name}", user_id: 1)
  end
  labels.each do |label|
    user.labels.create(name: label)
  end
end
