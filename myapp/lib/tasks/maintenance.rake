# frozen_string_literal: true

namespace :maintenance do
  desc 'Helloを表示するタスク'
  task start: :environment do
    mainte_flg = Rails.root.join '/myapp/tmp/maintenance_mode_on.txt'

    if File.exist? mainte_flg
      puts '既にメンテナンスモード起動中'
    else
      File.open mainte_flg, 'w+'
      puts 'メンテナンスモード起動しました。'
    end
  end

  task stop: :environment do
    mainte_flg = Rails.root.join '/myapp/tmp/maintenance_mode_on.txt'
    if File.exist? mainte_flg
      File.delete mainte_flg
      puts 'メンテナンスモード停止しました。'
    else
      puts 'メンテナンスモードではないです。'
    end
  end
end
