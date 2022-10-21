namespace :system_maintenance do
  desc '機能開始/停止'
  task :change_system_maintenance_status, ['id', 'maintenance_flg'] => :environment do |task, args|
    puts 'start---------------------------'
    if args.id.nil? || args.maintenance_flg.nil?
      puts 'must be set args'
      puts 'end-----------------------------'
      next
    end
    systemMaintenance = SystemMaintenance.find_by(key: args.id.to_i)
    systemMaintenance.update(maintenance_flg: args.maintenance_flg == '1' ? true : false)
    puts "key: #{systemMaintenance.key}, maintenance_flg: #{systemMaintenance.maintenance_flg}"
    puts 'end-----------------------------'
  end
end
