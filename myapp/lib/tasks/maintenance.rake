require 'fileutils'

namespace :maintenance do
  desc 'メンテナンススタート'
  task start: :environment do
    if File.exist?(Constants::MAINTENANCE_FILE_PATH)
      puts '既にメンテナンスモードです'
    else
      # tmp/maintenance.txtを作成
      FileUtils.touch(Constants::MAINTENANCE_FILE_PATH)
      puts 'メンテナンスモードを開始します'
    end
  end

  desc 'メンテナンス終了'
  task end: :environment do
    if File.exist?(Constants::MAINTENANCE_FILE_PATH)
      # tmp/maintenance.txtを削除
      File.delete(Constants::MAINTENANCE_FILE_PATH)
      puts 'メンテナンスモードを終了します'
    else
      puts '通常モードです'
    end
  end

  desc 'モードを確認'
  task status: :environment do
    if File.exist?(Constants::MAINTENANCE_FILE_PATH)
      puts 'メンテナンスモードです'
    else
      puts '通常モードです'
    end
  end
end
