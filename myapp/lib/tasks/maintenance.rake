require 'fileutils'
MAINTENANCE_FILE_PATH = Rails.root.join('tmp', 'maintenance.txt')

namespace :maintenance do
  desc 'メンテナンススタート'
  task :start do
    # tmp/maintenance.txtを作成
    FileUtils.touch(MAINTENANCE_FILE_PATH) unless File.exist?(MAINTENANCE_FILE_PATH)
  end

  desc 'メンテナンス終了'
  task :end do
    # tmp/maintenance.txtを削除
    File.delete(MAINTENANCE_FILE_PATH) if File.exist?(MAINTENANCE_FILE_PATH)
  end
end
