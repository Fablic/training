namespace :mentenances do
  desc 'メンテナンスモード on'
  task mentenance_on: :environment do
    require 'fileutils'
    FileUtils.touch('/tmp/MAINTENANCE')
  end

  desc 'メンテナンスモード off'
  task mentenance_off: :environment do
    require 'fileutils'
    FileUtils.rm('/tmp/MAINTENANCE')
  end
end
