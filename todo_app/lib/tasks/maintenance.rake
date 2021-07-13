# frozen_string_literal: true

namespace :maintenance do
  desc 'start maintenance'
  task start: :environment do
    if File.exist?(Constants::MAINTENANCE_DIR)
      puts 'メンテナンスモードは既に開始済みです'
    else
      FileUtils.touch(Constants::MAINTENANCE_DIR)
      puts 'メンテナンスモードを開始します'
    end
  end

  desc 'end maintenance'
  task end: :environment do
    if File.exist?(Constants::MAINTENANCE_DIR)
      FileUtils.rm(Constants::MAINTENANCE_DIR)
      puts 'メンテナンスモードを終了します'
    else
      puts 'メンテナンスモードは既に終了済みです'
    end
  end
end
