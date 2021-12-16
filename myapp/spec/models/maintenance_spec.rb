# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maintenance, type: :model do
  let(:maintenance_file_path) { described_class::MAINTENANCE_FILE_PATH }

  describe '#start' do
    after { FileUtils.rm_f maintenance_file_path }

    example 'Maintenance file is placed.' do
      described_class.start
      expect(File).to exist(maintenance_file_path)
    end
  end

  describe '#stop' do
    before {
      FileUtils.touch maintenance_file_path
    }

    example 'Maintenance file is deleted.' do
      described_class.stop
      expect(File).not_to exist(maintenance_file_path)
    end
  end

  describe '#status' do
    context 'when in maintenance' do
      example 'status is true' do
        described_class.start
        expect(described_class.status?).to eq true
      end
    end

    context 'when out of maintenance' do
      example 'status is false' do
        described_class.stop
        expect(described_class.status?).to eq false
      end
    end
  end
end
