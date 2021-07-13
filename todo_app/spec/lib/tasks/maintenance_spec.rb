# frozen_string_literal: true

require 'rails_helper'
require 'rake'

RSpec.describe 'Maintenance task' do
  let(:file) { Rails.root.join(Constants::MAINTENANCE_DIR) }

  before(:all) do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require 'tasks/maintenance'
    Rake::Task.define_task(:environment)
  end

  before(:each) { @rake[task_name].reenable }

  describe 'start' do
    let(:task_name) { 'maintenance:start' }

    context 'ファイルが存在する場合' do
      it '「メンテナンスモードは既に開始済みです」が表示されること' do
        expect do
          FileUtils.touch(Constants::MAINTENANCE_DIR)
          @rake[task_name].invoke
        end.to output("メンテナンスモードは既に開始済みです\n").to_stdout
      end
    end

    context 'ファイルが存在しない場合' do
      it '「メンテナンスモードを開始します」と表示される' do
        expect do
          FileUtils.rm(Constants::MAINTENANCE_DIR)
          @rake[task_name].invoke
        end.to output("メンテナンスモードを開始します\n").to_stdout
      end
    end
  end

  describe 'end' do
    let(:task_name) { 'maintenance:end' }

    context 'ファイルが存在する場合' do
      it '「メンテナンスモードを終了します」が表示されること' do
        expect do
          FileUtils.touch(Constants::MAINTENANCE_DIR)
          @rake[task_name].invoke
        end.to output("メンテナンスモードを終了します\n").to_stdout
      end
    end

    context 'ファイルが存在しない場合' do
      it '「メンテナンスモードは既に終了済みです」が表示されること' do
        expect do
          @rake[task_name].invoke
        end.to output("メンテナンスモードは既に終了済みです\n").to_stdout
      end
    end
  end
end
