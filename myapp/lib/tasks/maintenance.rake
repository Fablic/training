# frozen_string_literal: true

namespace :maintenance do
  desc 'メンテナンスモード設定'
  task start: :environment do
    Maintenance.start
    puts 'メンテナンスにしました'
  end

  desc 'メンテナンスモード解除'
  task stop: :environment do
    Maintenance.stop
    puts 'メンテナンス解除しました'
  end

  desc 'メンテナンスモード状態取得'
  task status: :environment do
    puts Maintenance.status? ? 'メンテナンス中です' : 'メンテナンス解除中です'
  end
end
