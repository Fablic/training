MAINTENANCE_FILE = './tmp/maintenance.yml'.freeze

namespace :maintenance_mode do
  task start: :environment do
    File.open(MAINTENANCE_FILE, 'w') unless File.exist?(MAINTENANCE_FILE)
  end

  task end: :environment do
    File.delete(MAINTENANCE_FILE) if File.exist?(MAINTENANCE_FILE)
  end
end
