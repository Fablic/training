maintenance_file = Rails.root.join('tmp', 'maintenance.txt')
if File.exist?(maintenance_file)
  File.delete(maintenance_file)
  puts "Maintenance mode disabled."
else
  puts "Maintenance mode is not enabled."
end
