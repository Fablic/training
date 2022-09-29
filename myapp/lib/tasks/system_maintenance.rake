namespace :system_maintenance do
  desc '機能開始/停止'
  task :change_system_maintenance_status, ['id', 'status'] => :environment do |task, args|
    puts 'start-----------------'
    if args.id.nil? || args.status.nil?
      puts 'must be set args'
      puts 'end-------------------'
      next
    end
    systemMaintenance = SystemMaintenance.find_by(key: args.id.to_i)
    systemMaintenance.update(status: args.status)
    puts "key: #{systemMaintenance.key}, status: #{systemMaintenance.status}"
    puts 'end-------------------'
  end
end
