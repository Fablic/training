namespace :maintenance do
  desc 'maintenance batch'

  task :start do
    File.write('tmp/maintenance.txt', '')
    puts 'start maintenance'
  end

  task :finish do
    next unless File.exist?('tmp/maintenance.txt')
    File.delete('tmp/maintenance.txt')
    puts 'maintenance finished'
  end
end
