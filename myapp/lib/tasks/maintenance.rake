# frozen_string_literal: true

# lib/tasks/maintenance.rake
namespace :maintenance do
  desc 'Turn on maintenance mode'
  task on: :environment do
    File.open(Rails.root.join('tmp', 'maintenance_mode'), 'w') do |f|
      f.puts 'on'
    end
    puts 'Maintenance mode is turned ON.'
  end

  desc 'Turn off maintenance mode'
  task off: :environment do
    File.delete(Rails.root.join('tmp', 'maintenance_mode')) if File.exist?(Rails.root.join('tmp', 'maintenance_mode'))
    puts 'Maintenance mode is turned OFF.'
  end
end
