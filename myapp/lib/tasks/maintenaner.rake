namespace :maintenaner do
  desc 'メンテナンス切替'
  task start: :environment do
    maintenance = Maintenance.find_by(service_id: TASK)
    if maintenance.present? && maintenance.update(maintenance_flg: true)
      # 動作確認のため出力
      puts 'メンテナンス開始'
    else
      # 動作確認のため出力
      puts 'メンテナンス開始に失敗しました'
    end
  end

  task stop: :environment do
    maintenance = Maintenance.find_by(service_id: TASK)
    puts maintenance.service_id
    if maintenance.present? && maintenance.update(maintenance_flg: false)
      # 動作確認のため出力
      puts 'メンテナンス停止'
    else
      # 動作確認のため出力
      puts 'メンテナンス停止に失敗しました'
    end
  end
end
