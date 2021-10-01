namespace :maintenance do
  task :start do
    unless File.exist?('tmp/maintenance.txt')
      File.open('tmp/maintenance.txt', 'w+') do |f|
        f.write('maintenance on')
      end
    end
  end

  task :stop do
    if File.exist?('tmp/maintenance.txt')
      File.delete('tmp/maintenance.txt')
    end
  end
end
