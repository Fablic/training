namespace :maintenance do
  desc 'Begin maintenance'
  task :begin, [:retry_after] => :environment do |_t, args|
    retry_after = args[:retry_after].then { |v| v ? Integer(v) : 3600 }
    Rack::Maintenance::MAINTENANCE_YAML.write(
      YAML.dump(
        'retry_after' => retry_after,
      ),
    )
  end

  desc 'End maintenance'
  task :end => :environment do
    FileUtils.rm_f(Rack::Maintenance::MAINTENANCE_YAML)
  end
end
