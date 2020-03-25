# frozen_string_literal: true

require 'rails_helper'
require 'rake'

describe 'maintenance' do
  before(:all) do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require('maintenance', ["#{Rails.root}/lib/tasks"])
    Rake::Task.define_task(:environment)
  end

  subject {
    open('config/maintenance.yml', 'r') { |f| YAML.load(f) }['maintenance_mode']
  }

  describe 'maintenance:start' do
    it 'maintenance value of config/maintenance.yml is changed to true' do
      @rake['maintenance:start'].invoke
      is_expected.to be_truthy
    end
  end

  describe 'maintenance:end' do
    it 'maintenance value of config/maintenance.yml is changed to false' do
      @rake['maintenance:end'].invoke
      is_expected.to be_falsey
    end
  end
end

