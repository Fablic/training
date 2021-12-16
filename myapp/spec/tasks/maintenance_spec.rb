# frozen_string_literal: true

require 'rake_helper'

describe 'MaintenanceTask' do
  let(:maintenance_file_path) { Maintenance::MAINTENANCE_FILE_PATH }

  describe 'maintainance:start' do
    subject(:task) { Rake.application['maintenance:start'] }

    after { File.delete(Maintenance::MAINTENANCE_FILE_PATH) }

    example 'set maintenance mode' do
      expect { task.invoke }.to output("メンテナンスにしました\n").to_stdout
    end
  end

  describe 'maintainance:stop' do
    subject(:task) { Rake.application['maintenance:stop'] }

    before { File.open(Maintenance::MAINTENANCE_FILE_PATH, 'w') }

    example 'unset maintenance mode' do
      expect { task.invoke }.to output("メンテナンス解除しました\n").to_stdout
    end
  end

  describe 'maintainance:status' do
    subject(:task) { Rake.application['maintenance:status'] }

    before { File.delete(Maintenance::MAINTENANCE_FILE_PATH) if File.exist?(Maintenance::MAINTENANCE_FILE_PATH) }

    after { File.delete(Maintenance::MAINTENANCE_FILE_PATH) if File.exist?(Maintenance::MAINTENANCE_FILE_PATH) }

    context 'when in maintenance' do
      before { Maintenance.start }

      example 'maintenance announcement is displayed' do
        expect { task.invoke }.to output("メンテナンス中です\n").to_stdout
      end
    end

    context 'when out of maintenance' do
      before { Maintenance.stop }

      example 'out of maintenance announcement is displayed' do
        expect { task.invoke }.to output("メンテナンス解除中です\n").to_stdout
      end
    end
  end
end
