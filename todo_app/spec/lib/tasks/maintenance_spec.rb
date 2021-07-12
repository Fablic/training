# frozen_string_literal: true

require 'rails_helper'
require 'rake'

RSpec.describe 'maintenance' do
  let(:file) { Rails.root.join(Constants::MAINTENANCE_DIR) }

  before(:all) do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require 'tasks/maintenance'
    Rake::Task.define_task(:environment)
  end

  before(:each) do
    @rake[task_name].reenable
  end

  describe 'start' do
    let(:task_name) { 'maintenance:start' }

    context 'test start' do
      it 'create file' do
        @rake[task_name].invoke
        visit login_path

        expect(File).to exist file
        expect(page).to have_content '誠に申し訳ありません。ただいまメンテナンス中です。'
      end
    end
  end

  describe 'finish' do
    let(:task_name) { 'maintenance:end' }

    context 'delete' do
      it 'delete file' do
        @rake[task_name].invoke
        visit login_path

        expect(File).not_to exist file
        expect(page).to have_content 'TODO App'
      end
    end
  end
end