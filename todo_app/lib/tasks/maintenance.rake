# frozen_string_literal: true

namespace :maintenance do
  desc 'start maintenance'
  task start: :environment do
    if File.exist?(Constants::MAINTENANCE)
      puts 'すでにメンテナンスモードです'
    elsif system("touch #{Constants::MAINTENANCE}")
      puts 'メンテナンスモードを開始します'
    else
      puts 'メンテナンスモード終了に失敗しました'
    end
  end

  desc 'end maintenance'
  task end: :environment do
    if system("rm #{Constants::MAINTENANCE}")
      puts 'メンテナンスモードを終了します'
    else
      puts 'メンテナンスモード終了に失敗しました'
    end
  end
end
