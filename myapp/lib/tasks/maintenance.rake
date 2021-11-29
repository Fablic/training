# frozen_string_literal: true

namespace :maintenance do
  desc 'Set maintenance mode'

  require 'fileutils'

  task start: :environment do
    if File.exist?(Constants::MAINTENANCE_FILE_PATH)
      p 'Already in maintenance mode'
    else
      p 'Set maintenance mode'
      FileUtils.touch(Constants::MAINTENANCE_FILE_PATH)
    end
  end

  task stop: :environment do
    if File.exist?(Constants::MAINTENANCE_FILE_PATH)
      p 'Cancel maintenance mode'
      FileUtils.rm(Constants::MAINTENANCE_FILE_PATH)
    else
      p 'Not already in maintenance mode'
    end
  end
end
