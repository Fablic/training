class Batch::Maintenance
  # メンテ開始
  def self.start
    # メンテナンスステータスを取得
    mainte = Maintenance.find(1)

    # メンテナンスモードじゃない
    if mainte.status.zero?
      # メンテモードのフラグを立てる
      mainte.status = 1
      mainte.save

      puts '--- メンテナンスを開始します ---'
      puts '- データ取得開始 -'
      task_count = Task.count.to_s
      user_count = User.count.to_s
      puts '- データ取得終了 -'
      puts 'タスク登録件数：' + task_count
      puts 'ユーザ数：' + user_count

    # すでにメンテモードだった
    else
      puts 'すでにメンテ中です！！'
    end
  end

  # メンテ終了
  def self.end
    # メンテナンスステータスを取得
    mainte = Maintenance.find(1)

    # メンテナンスモードじゃない
    if mainte.status.zero?
      puts 'メンテナンスモードはすでに終了しています！！'
    else
      # メンテモードフラグを終了にセット
      mainte.status = 0
      mainte.save
      puts '--- メンテナンスモード終了しました ---'
    end
  end
end
