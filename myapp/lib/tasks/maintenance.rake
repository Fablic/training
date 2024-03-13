desc 'Start maintenance mode'
task 'maintenance_go:start' => :environment do
  puts 'Start maintenance mode!'
  File.write('tmp/maintenance.txt', '')
  puts 'Maintenance mode started!'
end

desc 'Stop maintenance mode'
task 'maintenance_go:end' => :environment do
  FileUtils.rm_f('tmp/maintenance.txt')
  puts 'Maintenance mode ended!'
end