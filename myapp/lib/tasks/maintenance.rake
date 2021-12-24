# frozen_string_literal: true

namespace :maintenance do
    desc 'メンテナンスモード設定'
    task start: :environment do
        FileUtils.touch('tmp/maintenance.txt')
        p 'メンテナンスモード設定完了'
    end

    desc 'メンテナンスモード解除'
    task stop: :environment do
        FileUtils.rm('tmp/maintenance.txt')
        p 'メンテナンス解除完了'
    end
  end
