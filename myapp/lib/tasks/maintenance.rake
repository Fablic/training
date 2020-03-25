namespace :maintenance do
  task start: :environment do
    puts 'maintenance start'
    check_to_exist_and_to_create_maintenance_file
    data = { 'maintenance_mode' => true }
    File.open('config/maintenance.yml', 'w') { |f| YAML.dump(data, f) }
  end

  task end: :environment do
    puts 'maintenance end'
    check_to_exist_and_to_create_maintenance_file
    data = { 'maintenance_mode' => false }
    File.open('config/maintenance.yml', 'w') { |f| YAML.dump(data, f) }
  end

  def check_to_exist_and_to_create_maintenance_file
    unless File.exist? 'config/maintenance.yml'
      sh "touch config/maintenance.yml"
    end
  end
end

