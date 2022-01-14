# frozen_string_literal: true

namespace :maintenance do
  task start: :environment do
    FileUtils.touch(Rails.configuration.maintenance_file)
  end

  task end: :environment do
    FileUtils.rm(Rails.configuration.maintenance_file) if File.exist?(Rails.configuration.maintenance_file)
  end
end
