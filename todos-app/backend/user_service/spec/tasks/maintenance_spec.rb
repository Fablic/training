# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Rake Maintenance', type: :task do
  after do
    FileUtils.rm(Rails.configuration.maintenance_file) if File.exist?(Rails.configuration.maintenance_file)
  end

  describe 'maintenance:start' do
    it 'creates maintenance lock file in temp dir' do
      Rake::Task['maintenance:start'].execute
      expect(File).to exist(Rails.configuration.maintenance_file)
    end
  end

  describe 'maintenance:end' do
    it 'removes maintenance lock file in temp dir' do
      Rake::Task['maintenance:end'].execute
      expect(File).not_to exist(Rails.configuration.maintenance_file)
    end
  end
end
