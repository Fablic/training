# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maintenance' do
  let(:file_path) { 'tmp/maintenance.txt' }

  after do
    FileUtils.rm_f(file_path)
  end

  describe 'start maintenance' do
    it 'show maintenance page', :aggregate_failures do
      Rake::Task['maintenance_go'].invoke
      expect(File).to exist(file_path)
      visit '/'
      expect(page).to have_content 'Maintenance time! (503)'
    end

    it 'show login page after the maintenance is done', :aggregate_failures do
      Rake::Task['maintenance_go'].invoke
      Rake::Task['maintenance_done'].invoke
      expect(File).not_to exist(file_path)
      visit '/'
      expect(page).to have_content 'Login'
    end
  end
end
