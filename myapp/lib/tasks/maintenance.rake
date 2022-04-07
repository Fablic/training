namespace :maintenance do
  desc 'メンテナンスをオンにします'
  task :on => :environment do
    maintenance = Constant.find_by(name: 'maintenance')
    maintenance.update(value: 'on')
    puts 'update on'
  end
  desc 'メンテナンスをオフにします'
  task :off => :environment do
    maintenance = Constant.find_by(name: 'maintenance')
    maintenance.update(value: 'off')
    puts 'update off'
  end
end
