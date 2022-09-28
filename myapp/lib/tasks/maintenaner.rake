namespace :maintenaner do
  desc 'メンテナンス切替'
  task start_all: :environment do
    maintenance = Maintenance.find_by(service_id: TASK)
    if maintenance.present? && maintenance.update(maintenance_flg: true)
      # 動作確認のため出力
      puts 'メンテナンス開始'
    else
      # 動作確認のため出力
      puts 'メンテナンス開始に失敗しました'
    end
  end

  task stop_all: :environment do
    maintenance = Maintenance.find_by(service_id: TASK)
    if maintenance.present? && maintenance.update(maintenance_flg: false)
      # 動作確認のため出力
      puts 'メンテナンス停止'
    else
      # 動作確認のため出力
      puts 'メンテナンス停止に失敗しました'
    end
  end

  task start_tasks: :environment do
    maintenance = Maintenance.find_by(service_id: TASKS)
    if maintenance.present? && maintenance.update(maintenance_flg: true)
      # 動作確認のため出力
      puts '一覧のメンテナンス開始'
    else
      # 動作確認のため出力
      puts '一覧のメンテナンス開始に失敗しました'
    end
  end

  task stop_tasks: :environment do
    maintenance = Maintenance.find_by(service_id: TASKS)
    if maintenance.present? && maintenance.update(maintenance_flg: false)
      # 動作確認のため出力
      puts '一覧のメンテナンス停止'
    else
      # 動作確認のため出力
      puts '一覧のメンテナンス停止に失敗しました'
    end
  end

  task start_create: :environment do
    maintenance = Maintenance.find_by(service_id: CREATE)
    if maintenance.present? && maintenance.update(maintenance_flg: true)
      # 動作確認のため出力
      puts '登録画面のメンテナンス開始'
    else
      # 動作確認のため出力
      puts '登録画面のメンテナンス開始に失敗しました'
    end
  end

  task stop_create: :environment do
    maintenance = Maintenance.find_by(service_id: CREATE)
    if maintenance.present? && maintenance.update(maintenance_flg: false)
      # 動作確認のため出力
      puts '登録画面のメンテナンス停止'
    else
      # 動作確認のため出力
      puts '登録画面のメンテナンス停止に失敗しました'
    end
  end

  task start_update: :environment do
    maintenance = Maintenance.find_by(service_id: UPDATE)
    if maintenance.present? && maintenance.update(maintenance_flg: true)
      # 動作確認のため出力
      puts '更新画面のメンテナンス開始'
    else
      # 動作確認のため出力
      puts '更新画面のメンテナンス開始に失敗しました'
    end
  end

  task stop_update: :environment do
    maintenance = Maintenance.find_by(service_id: UPDATE)
    if maintenance.present? && maintenance.update(maintenance_flg: false)
      # 動作確認のため出力
      puts '更新画面のメンテナンス停止'
    else
      # 動作確認のため出力
      puts '更新画面のメンテナンス停止に失敗しました'
    end
  end

  task start_show: :environment do
    maintenance = Maintenance.find_by(service_id: SHOW)
    if maintenance.present? && maintenance.update(maintenance_flg: true)
      # 動作確認のため出力
      puts '詳細画面のメンテナンス開始'
    else
      # 動作確認のため出力
      puts '詳細画面のメンテナンス開始に失敗しました'
    end
  end

  task stop_show: :environment do
    maintenance = Maintenance.find_by(service_id: SHOW)
    if maintenance.present? && maintenance.update(maintenance_flg: false)
      # 動作確認のため出力
      puts '詳細画面のメンテナンス停止'
    else
      # 動作確認のため出力
      puts '詳細画面のメンテナンス停止に失敗しました'
    end
  end
end
