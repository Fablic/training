# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maintenance, type: :model do
  let(:maintenance) { described_class }
  let(:maintenance_file_path) { maintenance::MAINTENANCE_FILE_PATH }

  describe '#start' do
    before {
      maintenance.start
    }

    after { File.delete(maintenance_file_path) }

    example 'Maintenance file is placed.' do
      expect(File).to exist(maintenance_file_path)
    end
  end

  describe '#stop' do
    before {
      File.open(maintenance_file_path, 'w')
    }

    example 'Maintenance file is deleted.' do
      maintenance.stop
      expect(File).not_to exist(maintenance_file_path)
    end
  end

  describe '#status' do
    context 'when in maintenance' do
      example 'status is true' do
        maintenance.start
        expect(maintenance.status?).to eq true
      end
    end

    context 'when out of maintenance' do
      example 'status is false' do
        maintenance.stop
        expect(maintenance.status?).to eq false
      end
    end
  end
end
