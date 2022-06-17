# frozen_string_literal: true

namespace :maintenance do
  desc 'starting maintenance mode'
  task start: :environment do
    if File.exist?(Constants::MAINTENANCE_FILE_PATH)
      puts 'It is already mentenance mode'
      exit
    end

    FileUtils.touch(Constants::MAINTENANCE_FILE_PATH)
    puts 'Started mentenance mode'
  end

  desc 'Stopping maintenance mode'
  task stop: :environment do
    unless File.exist?(Constants::MAINTENANCE_FILE_PATH)
      puts 'Not in maintenance mode'
      exit
    end

    FileUtils.rm(Constants::MAINTENANCE_FILE_PATH)
    puts 'Stopped maintenance mode'
  end
end
