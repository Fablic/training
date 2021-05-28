namespace :maintenance do
  desc 'Begin maintenance'
  task :begin, [:retry_after] => :environment do |_t, args|
    retry_after = args[:retry_after].then { |v| v ? Integer(v) : 3600 }
    Rack::Maintenance.start(retry_after)
  end

  desc 'End maintenance'
  task :end => :environment do
    Rack::Maintenance.finish
  end
end
