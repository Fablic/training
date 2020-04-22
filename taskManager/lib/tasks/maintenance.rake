namespace :maintenance do
  desc 'maintenance mode'
  task :on do
    unless File.exist?('tmp/maintenance.txt')
      File.open('tmp/maintenance.txt', 'w') do |f|
        f.write('on')
      end
    end
    puts 'on'
  end

  task :off do
    puts 'close'
    File.delete('tmp/maintenance.txt')
  end
end
