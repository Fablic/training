require 'rails_helper'
require 'rake'

RSpec.describe 'Maintenance' do
  let(:file_path) { 'tmp/maintenance.txt' }

  after do
    FileUtils.rm_f(file_path)
  end

  describe 'start maintenance' do
    it 'displays the maintenance page', :aggregate_failures do
      Rake::Task['maintenance_go:start'].invoke
      expect(File).to exist(file_path)
      visit '/'
      expect(page).to have_content 'Sorry! We are under maintainence'
    end

    it 'show login page after the maintenance is done', :aggregate_failures do
      Rake::Task['maintenance_go:start'].invoke
      Rake::Task['maintenance_go:end'].invoke
      expect(File).not_to exist(file_path)
      visit '/'
      expect(page).to have_content 'Login'
    end
  end
end

