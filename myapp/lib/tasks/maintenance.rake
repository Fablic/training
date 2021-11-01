

namespace :maintenance  do
    task :start, [:message] => :environment do |_task, args|
         puts "maintenance message - #{args[:message]}"
        Maintenance.all.destroy_all
        Maintenance.create(created_by:1, name: args[:message]  )
    end

    task :end => :environment do
        Maintenance.all.destroy_all
        
    end
end
