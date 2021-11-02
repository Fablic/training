namespace :maintenance do
  task start: :environment do
    if File.exist?(Constants::MAINTENANCE_FILE_PATH)
      puts 'Under maintenance'
    else
      puts 'maintenance start.'
      FileUtils.touch(Constants::MAINTENANCE_FILE_PATH)
    end
  end

  task stop: :environment do
    if File.exist?(Constants::MAINTENANCE_FILE_PATH)
      puts 'maintenance stop.'
      FileUtils.remove(Constants::MAINTENANCE_FILE_PATH)
    else
      puts 'Not under maintenance.'
    end
  end

  task status: :environment do
    puts File.exist?(Constants::MAINTENANCE_FILE_PATH) ? 'Under maintenance' : 'Not under maintenance.'
  end
end
