namespace :maintenance do
  task start: :environment do
    File.open(Rails.root.join('tmp', 'maintenance.txt'), 'w') do |file|
      file.puts "Maintenance started at #{Time.now}"
    end

    puts "Maintenance mode enabled."
  end

  task end: :environment do
    file_path = Rails.root.join('tmp', 'maintenance.txt')

    if File.exist?(file_path)
      File.delete(file_path)
      puts "Maintenance mode disabled."
    else
      puts "Maintenance mode is not active."
    end
  end
end
