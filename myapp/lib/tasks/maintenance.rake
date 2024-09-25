namespace :maintenance do
  desc 'manage maintenance'
  # turn on or off maintenance with given datetime
  # args:
  # :is_maintenance... enum(off, on)
  # :started_at... ISO-8601, e.g. 2024-09-27T:12:00:00Z, 2014-10-10T13:50:40+09:00...etc
  # :ended_at... ISO-8601, e.g. 2024-09-27T:12:00:00Z, 2014-10-10T13:50:40+09:00...etc
  #
  # example:
  # rail maintenance:run[on,2024-09-27T:12:00:00Z,2024-09-30Y12:00:00Z]
  # rail maintenance:run[off,2024-09-27T:12:00:00Z,2024-09-30Y12:00:00Z]
  task :run, [:is_maintenance, :started_at, :ended_at] => :environment do |_, args|
    begin
      @maintenance = Maintenance.new({
                                       is_maintenance: args.is_maintenance,
                                       started_at: args.started_at,
                                       ended_at: args.ended_at,
                                     })
      @maintenance.save!
    rescue => e
      puts e.message
    end
  end
end
