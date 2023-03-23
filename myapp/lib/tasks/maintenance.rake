namespace :maintenance do
  desc 'maintenance'
  task :start do
    File.write('tmp/maintenance.txt', '')
  end

  task :finish do
    next unless File.exist?('tmp/maintenance.txt')

    File.delete('tmp/maintenance.txt')
  end
end
