# frozen_string_literal: true

namespace :maintainance do
  desc 'メンテナンスモードにする'
  task on: :environment do
    Maintainance.on(ENV['reason'])
  end

  desc 'メンテナンスモードを終了する'
  task off: :environment do
    Maintainance.off
  end
end
