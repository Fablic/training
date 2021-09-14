require 'rails_helper'
require 'rake'

describe 'rake task csv' do
  before(:all) do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require 'tasks/maintainance'
    Rake::Task.define_task(:environment)
  end

  before(:each) do
    @rake[task].reenable
  end

  describe 'maintainance:on' do
    let(:task) { 'maintainance:on' }
    after { File.delete('./config/maintanance.txt') }
    context "引数なし" do
      it {
        @rake[task].invoke
        file = File.open('./config/maintanance.txt', 'r')
        expect(file.read).to match '\n'
      }
    end

    context "引数あり" do
      before { allow(ENV).to receive(:[]).with('reason').and_return('サーバー障害のため') }
      it {
        @rake[task].invoke
        file = File.open('./config/maintanance.txt', 'r')
        expect(file.read).to match "サーバー障害のため\n"
      }
    end
  end

  describe 'maintainance:off' do
    let(:task) { 'maintainance:off' }
    before { File.open('./config/maintanance.txt', 'w') }
    it {
      @rake[task].invoke
      expect(File.exist?('./config/maintanance.txt')).to be_falsey
    }
  end
end