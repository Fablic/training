# frozen_string_literal: true

namespace :maintenance do
  desc 'Start maintenance mode'
  task start: :environment do
    if File.exist?(Constants::MAINTENANCE_FILE_PATH)
      puts 'Already in maintenance mode'
    else
      FileUtils.touch(Constants::MAINTENANCE_FILE_PATH)
      puts 'Started maintenance mode'
    end
  end

  desc 'Stop maintenance mode'
  task stop: :environment do
    if File.exist?(Constants::MAINTENANCE_FILE_PATH)
      FileUtils.rm(Constants::MAINTENANCE_FILE_PATH)
      puts 'Stopped maintenance mode'
    else
      puts 'Not in maintenance mode yet'
    end
  end
end
