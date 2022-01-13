# frozen_string_literal: true

namespace :maintenance do
  task start: :environment do
    FileUtils.touch(Rails.root.join('tmp', 'maintenance.lock'))
  end

  task end: :environment do
    FileUtils.rm(Rails.root.join('tmp', 'maintenance.lock'))
  end
end
