# このSeedは開発環境で実データを作成するための運用です。
# 本番での使用はしない想定です。

99.times do |n|
  name = Faker::Types.rb_string
  description = "これは説明です。#{n + 1}"
  deadline_at = Faker::Time.between(from: DateTime.now + 1, to: DateTime.now + 30)
  status = Task.statuses.keys.sample
  created_at = Faker::Time.between(from: DateTime.now - 30, to: DateTime.now)
  updated_at = Faker::Time.between(from: DateTime.now - 30, to: DateTime.now)
  Task.create!(name: name,
               description: description,
               deadline_at: deadline_at,
               status: status,
               created_at: created_at,
               updated_at: updated_at)
end
