# frozen_string_literal: true

namespace :maintenance do
  desc 'メンテナンスバッチ'

  task execute: :environment do
    if File.exist?('/myapp/tmp/maintenance.txt')
      File.delete('/myapp/tmp/maintenance.txt')
      puts 'メンテナンスモード終了ッ！'
    else
      File.open('/myapp/tmp/maintenance.txt', 'w+')
      puts 'メンテナンスモード開始ッ！'
    end
  end
end
