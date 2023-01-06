# frozen_string_literal: true

require 'rake_helper'

describe 'maintenance:' do
  describe 'start' do
    subject(:task) { Rake.application['maintenance:start'] }

    after do
      Rake.application['maintenance:stop'].invoke
    end

    it 'change_to_published' do
      task.invoke
      expect(File.exist?('/myapp/tmp/maintenance.txt')).to eq true
    end
  end

  describe 'stop' do
    subject(:task) { Rake.application['maintenance:stop'] }

    before do
      Rake.application['maintenance:start'].invoke
    end

    it 'change_to_published' do
      subject.invoke
      expect(File.exist?('/myapp/tmp/maintenance.txt')).to eq false
    end
  end
end
