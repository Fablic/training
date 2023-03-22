namespace :maintenance do
  desc 'maintenance'
  task :start do
    File.open('tmp/maintenance.txt', 'w'){ |f| f.write('')}
  end

  task :finish do
    next unless File.exist?('tmp/maintenance.txt')
    File.delete('tmp/maintenance.txt')
  end
end
