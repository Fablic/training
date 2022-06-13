require Rails.root.join('config/initializers/constants.rb')

namespace :maintenance do
  desc 'メンテナンスモード開始'
  task :start do
    FileUtils.touch(Rails.public_path.join(Constants::MAINTENANCE_FILE_PATH)) unless File.exist?(Rails.public_path.join(Constants::MAINTENANCE_FILE_PATH))
  end

  desc 'メンテナンスモード停止'
  task :stop do
    FileUtils.rm(Rails.public_path.join(Constants::MAINTENANCE_FILE_PATH)) if File.exist?(Rails.public_path.join(Constants::MAINTENANCE_FILE_PATH))
  end
end
