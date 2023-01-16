# frozen_string_literal: true

namespace :maintenance do
  desc 'Maintenance starts'
  task starts: :environment do
    maintenance_mode = YAML.load_file('maintinance.yml').with_indifferent_access['mode']

    if maintenance_mode == 'on'
      puts "It's under maintenance already."
    else
      File.open('maintinance.yml', 'w') { |f| f.write 'mode: on' }
      puts 'Maintenance started...'
    end
  end

  task stops: :environment do
    maintenance_mode = YAML.load_file('maintinance.yml')['mode']

    if maintenance_mode == 'off'
      File.open('maintinance.yml', 'w') { |f| f.write 'mode: off' }
      puts 'Maintenance stopped...'
    else
      puts 'Maintenance is not on.'
    end
  end
end
