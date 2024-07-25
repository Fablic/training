File.open(Rails.root.join('tmp', 'maintenance.txt'), 'w') do |file|
  file.puts "Maintenance mode enabled at #{Time.now}"
end
puts "Maintenance mode enabled."
