# frozen_string_literal: true

namespace :maintenance do
  desc 'メンテナンスバッチ'

  task execute: :environment do
    temp = Rails.root.join '/myapp/tmp/maintenance.txt'

    if File.exist? temp
      File.delete temp
      puts 'メンテナンスモード終了ッ！'
    else
      File.open temp, 'w+'
      puts 'メンテナンスモード開始ッ！'
    end
  end
end
