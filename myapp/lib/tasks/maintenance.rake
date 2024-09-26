namespace :maintenance do
  desc 'Turn on maintenance with given datetime'
  # args:
  # :started_at... ISO-8601, e.g. 2024-09-27T:12:00:00Z, 2014-10-10T13:50:40+09:00...etc
  # :ended_at... ISO-8601, e.g. 2024-09-27T:12:00:00Z, 2014-10-10T13:50:40+09:00...etc
  #
  # example:
  # rails maintenance:run[2024-09-27T:12:00:00Z,2024-09-30T12:00:00Z]
  # rails maintenance:run[2024-09-27T:12:00:00Z,2024-09-30T12:00:00Z]
  task :on, [:started_at, :ended_at] => :environment do |task, args|
    begin
      @maintenance = Maintenance.new({
                                       is_maintenance: Maintenance.is_maintenances[:on],
                                       started_at: args.started_at,
                                       ended_at: args.ended_at,
                                     })
      @maintenance.save!
      puts "task '#{task}' executed with args started_at:#{args.started_at}, ended_at:#{args.ended_at}"
    rescue => e
      puts e.message
    end
  end

  desc 'Turn off maintenance'
  task :off => :environment do |task, _|
    begin
      @maintenance = Maintenance.new({
                                       is_maintenance: Maintenance.is_maintenances[:off],
                                     })
      @maintenance.save!
      puts "task '#{task}' executed"
    rescue => e
      puts e.message
    end
  end
end
