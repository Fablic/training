# frozen_string_literal: true

require 'rake_helper'

RSpec.describe 'メンテナンス切り替え' do # rubocop:disable RSpec/DescribeClass
  after do
    File.delete('on_maint') if File.exist?('on_maint')
  end

  let!(:start) { Rake.application['maint:start'] }
  let!(:stop) { Rake.application['maint:stop'] }

  describe 'maint:start' do
    subject { start }

    before do
      File.delete('on_maint') if File.exist?('on_maint')
    end

    it 'on_maintが生成される' do
      expect(File).not_to exist('on_maint')
      expect(start.invoke).to be_truthy
      expect(File).to exist('on_maint')
    end
  end

  describe 'maint:stop' do
    subject { stop }

    before do
      start.invoke
    end

    it 'on_maintが削除される' do
      expect(File).to exist('on_maint')
      expect(stop.invoke).to be_truthy
      expect(File).not_to exist('on_maint')
    end
  end
end
