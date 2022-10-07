# frozen_string_literal: true

require 'rake_helper'

RSpec.describe 'task_maintenance:start' do
  context "maintenance_check" do
    File.delete('tmp/maintenance.txt') if File.exist?('tmp/maintenance.txt')
    subject(:task) { Rake.application['task_maintenance:start'] }

    it 'change_to_maintenance_mode' do
      task.invoke
      expect(File.exist?('tmp/maintenance.txt')).to eq(true)
    end

    it 'change_to_normal_mode' do
      File.new('tmp/maintenance.txt', "w") unless File.exist?('tmp/maintenance.txt')
      task.invoke
      expect(File.exist?('tmp/maintenance.txt')).to eq(false)
    end
  end
end
