namespace :maintenance do
  desc 'Start maintenance mode'
  task start: :environment do
    Rails.application.config.maintenance_mode = true
    puts 'Maintenance mode started'
  end

  desc 'End maintenance mode'
  task end: :environment do
    Rails.application.config.maintenance_mode = false
    puts 'Maintenance mode ended'
  end
end
