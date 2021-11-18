# frozen_string_literal: true

require 'rake_helper'

RSpec.describe 'メンテナンス切り替え' do # rubocop:disable RSpec/DescribeClass
  after do
    File.delete('on_maint') if File.exist?('on_maint')
  end

  describe 'maint:start' do
    let!(:start) { Rake.application['maint:start'] }

    before do
      File.delete('on_maint') if File.exist?('on_maint')
    end

    it 'on_maintが生成される' do
      expect(start.invoke).to be_truthy
      expect(File).to exist('on_maint')
    end
  end

  describe 'maint:stop' do
    let!(:stop) { Rake.application['maint:stop'] }

    before do
      require 'fileutils'
      FileUtils.touch('on_maint') unless File.exist?('on_maint')
    end

    it 'on_maintが削除される' do
      expect(stop.invoke).to be_truthy
      expect(File).not_to exist('on_maint')
    end
  end
end
