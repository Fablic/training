# frozen_string_literal: true

require 'rake_helper'

describe 'MaintenanceTask' do
  let(:maintenance_file_path) { Maintenance::MAINTENANCE_FILE_PATH }

  describe 'maintainance:start' do
    subject(:task) { Rake.application['maintenance:start'] }

    after { FileUtils.rm_f(Maintenance::MAINTENANCE_FILE_PATH) }

    example 'set maintenance mode' do
      expect { task.invoke }.to output("メンテナンスにしました\n").to_stdout
    end

    example 'Maintenance.start is called' do
      allow(Maintenance).to receive(:start)
      task.invoke
      expect(Maintenance).to have_received(:start).once
    end
  end

  describe 'maintainance:stop' do
    subject(:task) { Rake.application['maintenance:stop'] }

    before {
      FileUtils.touch(Maintenance::MAINTENANCE_FILE_PATH)
    }

    example 'unset maintenance mode' do
      expect { task.invoke }.to output("メンテナンス解除しました\n").to_stdout
    end

    example 'Maintenance.stop is called' do
      allow(Maintenance).to receive(:stop)
      task.invoke
      expect(Maintenance).to have_received(:stop).once
    end
  end

  describe 'maintainance:status' do
    subject(:task) { Rake.application['maintenance:status'] }

    context 'when in maintenance' do
      before {
        allow(Maintenance).to receive(:status?).and_return(true)
      }

      example 'maintenance announcement is displayed' do
        expect { task.invoke }.to output("メンテナンス中です\n").to_stdout
      end
    end

    context 'when out of maintenance' do
      before {
        allow(Maintenance).to receive(:status?).and_return(false)
      }

      example 'out of maintenance announcement is displayed' do
        expect { task.invoke }.to output("メンテナンス解除中です\n").to_stdout
      end
    end
  end
end
