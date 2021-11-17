# frozen_string_literal: true

require 'rake_helper'

RSpec.describe 'メンテナンス切り替え' do # rubocop:disable RSpec/DescribeClass
  describe 'maint:start' do
    let!(:task) { Rake.application['maint:start'] }

    it 'on_maintが存在する' do
      expect(task.invoke).to be_truthy
      expect(File).to exist('on_maint')
    end
  end

  describe 'maint:stop' do
    let!(:task) { Rake.application['maint:stop'] }

    it 'on_maintが存在しない' do
      expect(task.invoke).to be_truthy
      expect(File).not_to exist('on_maint')
    end
  end
end
