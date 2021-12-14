# このSeedは開発環境で実データを作成するための運用です。
# 本番での使用はしない想定です。

user_name = 'shogo.kinjo'
email = 'shogo.kinjo@example.com'
password = 'password'
password_confirmation = 'password'
User.create!(name: user_name, email: email, password: password, password_confirmation: password_confirmation)

5.times do |n|
  name = "rakuten #{n}tarou"
  email = "rakuten.#{n}tarou@example.com"
  password = 'password'
  password_confirmation = 'password'
  User.create!(name: name, email: email, password: password, password_confirmation: password_confirmation)
end

user_ids = User.ids

99.times do |n|
  name = Faker::Types.rb_string
  user_id = user_ids.sample
  description = "これは#{n + 1}についての説明です。User.idは#{user_id}"
  deadline_at = Faker::Time.between(from: DateTime.now + 1, to: DateTime.now + 30)
  status = Task.statuses.keys.sample
  created_at = Faker::Time.between(from: DateTime.now - 30, to: DateTime.now)
  updated_at = Faker::Time.between(from: DateTime.now - 30, to: DateTime.now)
  Task.create!(name: name,
               description: description,
               deadline_at: deadline_at,
               status: status,
               user_id: user_id,
               created_at: created_at,
               updated_at: updated_at)
end
