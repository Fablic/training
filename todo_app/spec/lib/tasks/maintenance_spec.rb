# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'maintenance' do
  let(:dir) { 'users' }
  let(:file) { Rails.root.join("app/views/#{dir}/maintenance.html.erb") }

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
    let(:reason) { 'hogehoge' }

    context 'args are users directory and reason' do
      it 'create file' do
        @rake[task_name].invoke(dir, reason)
        visit sign_up_path

        expect(File).to exist(file)
        expect(page).to have_content('hogehoge')
      end
    end
  end

  describe 'finish' do
    let(:task_name) { 'maintenance:finish' }

    context 'arg is users direcotry' do
      it 'delete file' do
        @rake[task_name].invoke(dir)
        visit sign_up_path

        expect(File).not_to exist(file)
        expect(page).not_to have_content('hogehoge')
      end
    end
  end
end
